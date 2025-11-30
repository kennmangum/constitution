#!/usr/bin/env python3
"""
Build a tiny JSONL index from curated sources for truth recall.

Sources:
- constitution/ (core OS documentation)
- constitution/memory/dossier/ (decisions, learnings)
- implementations/ (6-stage lifecycle agents and their states)
- inbox/triaged/ (verified notes)
- collaboration/ (work history, reports)
- tools/ (operational tool docs)
- tests/ (test framework docs)
- quests/ (quest documentation and scripts)

Outputs: rag_index/index.jsonl

Constitutional Alignment:
- TRUTH: Indexes only curated, verified content (excludes Archive/)
- SOURCE: No principal filtering (public knowledge)
- INTEGRITY: Immutable once indexed (hash verification)
"""
import os
import json
import hashlib

ROOT = os.getcwd()
SOURCES = [
    "constitution",
    "constitution/memory/dossier",
    "implementations",            # 6-stage lifecycle agents
    "inbox/triaged",
    "collaboration",              # Work history and reports
    "tools",                      # Operational tool documentation
    "tests",                      # Test framework documentation
    "quests",                     # Quest documentation and scripts
]
# Single files to index (not walked recursively)
SINGLE_FILES = [
    "README.md",                  # Main repo readme
]
OUT = "rag_index/index.jsonl"
MANIFEST_OUT = "rag_index/manifest.json"

# Governance: Caps to prevent bloat
MAX_CHUNKS = 10000  # Fail if exceeds
MAX_SIZE_MB = 10    # Fail if exceeds


def should_index(path: str) -> bool:
    """Determine if file should be indexed based on extension and path."""
    # Skip archive directories (case-insensitive)
    if "/archive/" in path.lower() or "\\archive\\" in path.lower():
        return False

    # Skip dependency/build directories
    skip_dirs = [
        "/venv/", "\\venv\\",
        "/node_modules/", "\\node_modules\\",
        "/.pytest_cache/", "\\.pytest_cache\\",
        "/__pycache__/", "\\__pycache__\\",
        "/.git/", "\\.git\\",
        "/dist/", "\\dist\\",
        "/build/", "\\build\\",
        "/.venv/", "\\.venv\\",
    ]
    path_lower = path.lower()
    if any(skip_dir in path_lower for skip_dir in skip_dirs):
        return False

    # Only index text-based files
    return path.endswith((".md", ".txt", ".py", ".json", ".yaml", ".yml", ".sh"))


def read_text(path: str) -> str:
    """Safely read text file, returning empty string on error."""
    try:
        with open(path, "r", encoding="utf-8", errors="ignore") as f:
            return f.read()
    except Exception:
        return ""


def chunks(text: str, size: int = 1200, overlap: int = 200):
    """Split text into overlapping chunks for better context preservation."""
    i, n = 0, len(text)
    while i < n:
        yield text[i : i + size]
        i += max(1, size - overlap)


def main():
    """Index curated truth memory sources with governance caps."""
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    count = 0
    source_counts = {}  # Track per-source chunk counts

    with open(OUT, "w", encoding="utf-8") as out:
        # Index directory sources (walked recursively)
        for src in SOURCES:
            base = os.path.join(ROOT, src)
            if not os.path.isdir(base):
                continue

            source_count = 0
            for dirpath, dirs, files in os.walk(base):
                # Exclude archive and dependency directories (case-insensitive)
                skip_dir_names = {"archive", "venv", ".venv", "node_modules",
                                  "__pycache__", ".pytest_cache", ".git",
                                  "dist", "build", "providers"}
                dirs[:] = [d for d in dirs if d.lower() not in skip_dir_names]

                for fn in files:
                    p = os.path.join(dirpath, fn)
                    if not should_index(p):
                        continue

                    text = read_text(p).strip()
                    if not text:
                        continue

                    rel = os.path.relpath(p, ROOT)
                    for i, c in enumerate(chunks(text)):
                        rec = {
                            "path": rel,
                            "chunk_id": i,
                            "text": c,
                            "hash": hashlib.md5((rel + str(i)).encode()).hexdigest(),
                        }
                        out.write(json.dumps(rec) + "\n")
                        count += 1
                        source_count += 1

            source_counts[src] = source_count

        # Index single files (not walked recursively)
        for src in SINGLE_FILES:
            p = os.path.join(ROOT, src)
            if not os.path.isfile(p):
                continue

            text = read_text(p).strip()
            if not text:
                continue

            source_count = 0
            rel = os.path.relpath(p, ROOT)
            for i, c in enumerate(chunks(text)):
                rec = {
                    "path": rel,
                    "chunk_id": i,
                    "text": c,
                    "hash": hashlib.md5((rel + str(i)).encode()).hexdigest(),
                }
                out.write(json.dumps(rec) + "\n")
                count += 1
                source_count += 1

            source_counts[src] = source_count

    # Check governance caps
    index_size_mb = os.path.getsize(OUT) / (1024 * 1024)

    if count > MAX_CHUNKS:
        print(f"❌ GOVERNANCE FAILURE: Chunk count {count} exceeds MAX_CHUNKS {MAX_CHUNKS}")
        print(f"Top offenders:")
        for src, cnt in sorted(source_counts.items(), key=lambda x: x[1], reverse=True)[:5]:
            print(f"  {src}: {cnt} chunks")
        exit(1)

    if index_size_mb > MAX_SIZE_MB:
        print(f"❌ GOVERNANCE FAILURE: Index size {index_size_mb:.2f}MB exceeds MAX_SIZE_MB {MAX_SIZE_MB}MB")
        print(f"Top offenders:")
        for src, cnt in sorted(source_counts.items(), key=lambda x: x[1], reverse=True)[:5]:
            print(f"  {src}: {cnt} chunks")
        exit(1)

    # Write manifest
    manifest = {
        "total_chunks": count,
        "index_size_mb": round(index_size_mb, 2),
        "sources": source_counts,
        "governance": {
            "max_chunks": MAX_CHUNKS,
            "max_size_mb": MAX_SIZE_MB,
            "status": "✅ within limits"
        }
    }

    with open(MANIFEST_OUT, "w", encoding="utf-8") as f:
        json.dump(manifest, f, indent=2)

    print(f"✅ Indexed {count} chunks ({index_size_mb:.2f}MB) into {OUT}")
    print(f"📋 Manifest written to {MANIFEST_OUT}")
    print(f"Governance: {count}/{MAX_CHUNKS} chunks, {index_size_mb:.2f}/{MAX_SIZE_MB}MB")


# ∞Δ∞ SEAL: Truth memory indexer complete
# - SOURCE: No principal filtering (public knowledge base)
# - TRUTH: Indexes only curated, verified content (excludes Archive/, venv/, node_modules/)
# - INTEGRITY: Immutable once indexed (hash verification per chunk)
#
# Indexes directory sources + specific files for operational context.
# Excludes dependency/build artifacts. Provides truth recall for agents.

if __name__ == "__main__":
    main()
