# MCP Adapter Catalogue - Architectural Vision

**Date**: 2025-10-30 (late evening)
**Initiated by**: User (kmangum)
**Status**: Captured for future implementation
**Archon Project**: 475b791d-313c-44f1-b5a9-7e763e082c9d

---

## Vision

> "I'm envisioning an MCP catalogue for us here that functions like that on Docker desktop and could even link in there for now. I'd like for it to be treated like an adapter so we can plug into whatever they have there or whatever we build here."

**Core concept**: Pluggable MCP adapter catalogue enabling breath-aligned integrations with external services (social, productivity, data) via standardized adapter pattern.

---

## Why This Matters

### Lasting Generational Prosperity
- **Extensibility**: Future developers can add integrations without touching core system
- **Sovereignty**: Each adapter respects SOURCE/TRUTH/INTEGRITY principles
- **Composability**: Mix and match capabilities like Docker extensions
- **Community**: Leverage existing MCP Registry and Docker MCP Catalog

### Current Gap
- We have Archon MCP (project/task/document management)
- We don't have pluggable social, productivity, or external service integrations
- No standardized way to add new MCP servers
- Missing adapter pattern for constitutional compliance

---

## Existing Infrastructure (Discovered Oct 30, 2025)

### 1. Official MCP Registry
**URL**: https://registry.modelcontextprotocol.io
**Status**: Launched September 2025, API freeze v0.1 (stable until Nov 2025+)

**Capabilities**:
- Community-driven registry of MCP servers
- Open source (GitHub: modelcontextprotocol/registry)
- Sub-registry support (organizations can build custom registries)
- OpenAPI specification available

**Relevance**: We can plug into this as a consumer AND potentially publish our own adapters.

---

### 2. Docker MCP Catalog & Toolkit
**Announcement**: April 2025
**Integration**: Docker Desktop extension

**Capabilities**:
- 100+ verified MCP servers on Docker Hub (Stripe, Elastic, Neo4j, etc.)
- One-click setup for clients (Claude, Cursor, VSCode, Windsurf, continue.dev, Goose)
- Built-in OAuth support with secure credential storage
- Versioned, curated MCP servers packaged as Docker images
- Management interface in Docker Desktop

**Relevance**: We can leverage Docker's infrastructure for security, versioning, and distribution. Our catalogue could integrate with or extend Docker's.

---

## Proposed Architecture

### Constitutional Adapter Pattern

Each MCP adapter must enforce the triad:

#### SOURCE (Sovereignty)
- `principal_id` flows through all external calls
- Adapter declares ownership model
- Credential storage respects sovereignty
- No hardcoded identities

#### TRUTH (Reality Grounding)
- Service references must resolve
- Credentials validated before use
- API contracts verified
- No hallucinated capabilities

#### INTEGRITY (Gated State Changes)
- Write operations require approval gate
- Audit trail for external calls
- Loud failures with recovery hints
- Transactional safety where possible

---

### Adapter Interface (Draft)

```python
class ConstitutionalMCPAdapter:
    """Base adapter enforcing constitutional principles"""

    # Metadata
    name: str                      # e.g., "x.com", "linkedin"
    category: str                  # e.g., "social", "productivity"
    capabilities: list[str]        # e.g., ["read", "write", "search"]
    version: str                   # Semantic versioning

    # Constitutional
    def validate_principal(self, principal_id: str) -> bool:
        """SOURCE: Verify principal has permission"""

    def resolve_credentials(self, principal_id: str) -> dict:
        """TRUTH: Get valid credentials for principal"""

    def gate_write(self, operation: str, data: dict) -> ApprovalRequest:
        """INTEGRITY: Require approval for write operations"""

    # Operations
    def read(self, query: dict) -> dict:
        """Read operation (fetch data)"""

    def write(self, data: dict, approved: bool = False) -> dict:
        """Write operation (requires approval)"""

    def search(self, query: str) -> list[dict]:
        """Search operation"""

    # Errors
    def handle_error(self, error: Exception) -> dict:
        """Loud failure with recovery hints"""
```

---

## Adapter Categories

### Social Category
**Services**: x.com, instagram, linkedin, mastodon
**Use cases**:
- Read: Fetch posts, profiles, timelines (research, context gathering)
- Write: Create breath-aligned posts, replies, shares (with approval gates)
- Search: Find content, people, hashtags (discovery)

**Constitutional considerations**:
- Write operations MUST be gated (Propose → Approve → Execute)
- Personal data sovereignty (user owns their social graph)
- Rate limiting and quotas (TRUTH - respect service limits)

---

### Productivity Category
**Services**: Google Calendar, Gmail, Notion, Todoist
**Use cases**:
- Calendar: Schedule retrospectives, round planning
- Email: Notifications for gate approvals
- Notes: Sync learnings to external systems
- Tasks: Bi-directional sync with Archon

**Constitutional considerations**:
- Credential storage (OAuth tokens, API keys)
- Data ownership (user's calendar, not system's)
- Permission scoping (minimal access principle)

---

### Data Category
**Services**: PostgreSQL, MongoDB, S3, APIs
**Use cases**:
- rag_index persistence (vector DB integration)
- Archon external backup
- API integrations for third-party data

**Constitutional considerations**:
- Connection string security (no hardcoded credentials)
- Query validation (prevent injection)
- Audit logging (all data access tracked)

---

### Development Category
**Services**: GitHub, GitLab, CI/CD, package registries
**Use cases**:
- Already have some via Archon GitHub integration
- Expand: Auto-PR creation, CI/CD triggers, release management
- Helper publishing to package registries

**Constitutional considerations**:
- Code signing and verification
- Permission scoping (repo-specific access)
- Webhook security (validate signatures)

---

### Communication Category
**Services**: Slack, Discord, Telegram, Matrix
**Use cases**:
- Agent notifications (round complete, approval needed)
- Human-in-the-loop workflows (send message, wait for response)
- Team collaboration (share learnings, retrospectives)

**Constitutional considerations**:
- Message authenticity (verify source)
- Rate limiting (don't spam)
- Privacy (end-to-end encryption where possible)

---

## Integration Options

### Option 1: Docker Desktop Extension (Leverage Existing)
**Pros**:
- Docker already has MCP Toolkit with OAuth, credential storage, versioning
- 100+ verified servers available
- One-click setup, familiar UX
- Security infrastructure built-in

**Cons**:
- Requires Docker Desktop (not available everywhere)
- Limited customization of UI
- Docker-specific packaging

**Recommendation**: Start here for rapid prototyping. Docker's infrastructure solves security and distribution.

---

### Option 2: Web Interface (Standalone or Archon-Integrated)
**Pros**:
- Accessible anywhere (no Docker Desktop required)
- Full control over UX/UI
- Can integrate with Archon project management
- Visual adapter management (status, health, logs)

**Cons**:
- Need to build security infrastructure (OAuth, credential storage)
- Hosting and deployment complexity
- Version management and updates

**Recommendation**: Future evolution. Build after Docker prototype validates patterns.

---

### Option 3: CLI Tool (Programmatic Management)
**Pros**:
- Scriptable, automation-friendly
- Lightweight (no GUI dependencies)
- Can wrap Docker MCP Toolkit commands
- Breath-aligned (cli tools are natural for BNA)

**Cons**:
- Less discoverable than GUI
- Steeper learning curve for non-technical users
- Still need underlying adapter infrastructure

**Recommendation**: Build alongside Docker prototype. CLI as thin wrapper around Docker commands + constitutional checks.

---

### Option 4: Hybrid (All Three)
**Architecture**:
```
┌─────────────────────────────────────────┐
│  Constitutional MCP Adapter Registry    │
│  (Shared Backend)                       │
└───────────┬─────────────────────────────┘
            │
    ┌───────┼───────┬────────────┐
    │       │       │            │
┌───▼────┐ ┌▼──────▼┐ ┌────────▼─────┐
│ Docker │ │   Web   │ │     CLI      │
│Desktop │ │Interface│ │    Tool      │
│Extension│ │(Archon) │ │(claude-mcp)  │
└────────┘ └─────────┘ └──────────────┘
```

**Pros**:
- Users choose interface (Docker GUI, web UI, or CLI)
- Shared backend ensures consistency
- Each interface optimized for use case

**Cons**:
- Most complex to build and maintain
- Need clear interface contracts
- Version sync across frontends

**Recommendation**: End state. Start with Docker, add CLI, then web interface.

---

## Success Criteria

### Phase 1: Research & Design (Archon tasks created)
- ✅ Research existing MCP infrastructure
- ✅ Design constitutional adapter pattern
- ✅ Define adapter categories
- Document in architectural blueprint

### Phase 2: Proof of Concept
- Docker MCP Toolkit installed and tested
- One social adapter implemented (x.com or linkedin)
- Constitutional compliance validated (SOURCE/TRUTH/INTEGRITY)
- Approval gate workflow demonstrated

### Phase 3: Catalogue MVP
- 3-5 adapters across different categories
- CLI tool for adapter management
- Documentation and usage examples
- Helper for adding new adapters

### Phase 4: Production
- Web interface (Archon-integrated or standalone)
- Sub-registry for custom/private adapters
- Community contribution guidelines
- Full constitutional test suite

---

## Open Questions

### Technical
1. **Credential storage**: Use Docker's OAuth support or build our own?
2. **Adapter distribution**: Docker images, npm packages, or both?
3. **Version management**: How to handle adapter updates?
4. **Conflict resolution**: What if two adapters provide same capability?

### Constitutional
1. **Approval granularity**: Per-adapter, per-operation, or per-call?
2. **Principal mapping**: How do user principals map to external service identities?
3. **Audit retention**: How long to keep external call logs?
4. **Failure modes**: What happens if adapter becomes unavailable?

### Breath Alignment
1. **Discovery**: How does BNA discover available adapters?
2. **Selection**: How to choose right adapter for task?
3. **Learning**: Can adapters be harvested as helpers?
4. **Evolution**: Proposal → Scroll → Seal for adapters?

---

## Connection to Game Framework

**Adapters as Helpers**: Each MCP adapter is essentially a helper that enables new capabilities.

**Harvesting pattern**:
1. **Proposal**: "We need x.com integration"
2. **Scroll**: x.com adapter used successfully in Round 2, 3, 4
3. **Seal**: x.com adapter becomes standard capability, documented in constitutional adapter registry

**Game integration**:
- CEA can propose adapters needed for round
- BAB can use available adapters
- Retrospective documents adapter usage
- Helper harvesting includes adapter creation

---

## References

### External
- MCP Registry: https://registry.modelcontextprotocol.io
- Docker MCP Catalog: https://www.docker.com/products/mcp-catalog-and-toolkit/
- MCP Specification: https://modelcontextprotocol.io/specification/2025-03-26
- GitHub Registry: https://github.com/modelcontextprotocol/registry

### Internal
- Archon Project: 475b791d-313c-44f1-b5a9-7e763e082c9d
- Constitution@A1: `constitution/CONSTITUTION.md`
- Game Framework: `implementations/game/`
- Lumen's Taxonomy: `collaboration/Lumen/2025-10-30-proposal-scroll-seal-taxonomy.md`

---

## Timeline (Flexible)

**Not immediate** - This is architectural vision for future implementation.

**Suggested sequence**:
1. Complete Game Round 2 (validate game framework)
2. Research MCP infrastructure (understand what exists)
3. Design adapter pattern (constitutional compliance)
4. Build first social adapter (proof of concept)
5. Expand catalogue (additional categories)

**No pressure** - Capture now, implement when breath unfolds the need.

---

∞Δ∞

**Vision**: Pluggable MCP adapter catalogue enabling constitutional integrations
**Pattern**: Adapter → Category → Registry → Discovery → Usage → Learning → Harvesting
**Operating Value**: Lasting Generational Prosperity through composable, sovereign, breath-aligned integrations

**TRUTH**: Existing infrastructure discovered (MCP Registry + Docker MCP Catalog)
**INTEGRITY**: Constitutional adapter pattern captures SOURCE/TRUTH/INTEGRITY requirements
**SOURCE**: User's vision preserved for future development

**Status**: Captured and ready for when breath calls for implementation

∞Δ∞
