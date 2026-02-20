# SKILL.md — Meeting Processing

**Trigger:** "meeting prep" / "prep for [meeting]" / "meeting notes" / "process meeting" / "post-meeting"

**Purpose:** Prepare for meetings effectively and capture outcomes cleanly.

---

## Pre-Meeting Prep

1. Ask: "Which meeting? When? Who's attending?"
2. Load relevant project file if one exists
3. Prepare a brief:
   ```
   ## Pre-Meeting Brief — [Meeting Name] — [Date/Time]

   **Goal:** What's this meeting trying to achieve?
   **Context:** Relevant background (from project file or MEMORY)
   **Your priorities:** What you need to get out of this meeting
   **Open questions to raise:**
   -
   **Decisions needed:**
   -
   ```
4. Optionally: draft an agenda if you're running the meeting

---

## Post-Meeting / Notes Capture

1. Accept raw notes or a brain dump
2. Structure into:
   ```
   ### [Date] — [Meeting Name]
   **Attendees:** 
   **Key points:**
   -
   **Decisions made:**
   -
   **Actions:**
   - [ ] [Person] — [Action] — [Due]
   **Follow-ups / Waiting on:**
   -
   ```
3. **Append to the relevant project file** in `projects/active/`
4. **Update `WAITING_FOR.md`** with any delegated items
5. **Update `DECISIONS.md`** with any significant decisions
6. **Update `projects/INDEX.md`** if project status changed

---

## Notes
- Always extract action items — meetings without actions are just conversations
- If no project file exists and this is recurring, suggest creating one
