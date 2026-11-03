# PROFILE FEATURE - IMPLEMENTATION PLAN

> Status: PLANNING  
> Target: Complete functional profile system with connections + experience CRUD  
> Priority: P1 (core user feature)

---

## 1. DATABASE SCHEMA (Supabase)

### Required Tables

```sql
-- Already exists: profiles
-- Need to extend with:
ALTER TABLE profiles ADD COLUMN (
  headline VARCHAR(255),
  bio TEXT,
  is_open_to_join BOOLEAN DEFAULT false,
  connection_count INTEGER DEFAULT 0,
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Skill tags (new)
CREATE TABLE user_skills (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  skill_name VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id, skill_name),
  CHECK (array_length(string_to_array(skill_name, ''), 1) <= 5)
);

-- Experience (new)
CREATE TABLE user_experiences (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  organization VARCHAR(255) NOT NULL,
  start_month INTEGER,
  start_year INTEGER,
  end_month INTEGER,
  end_year INTEGER,
  is_current BOOLEAN DEFAULT false,
  description TEXT,
  media_url VARCHAR(500),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Connections (new) - bidirectional
CREATE TABLE user_connections (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  connected_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'accepted', 'rejected'
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id, connected_user_id),
  CHECK (user_id != connected_user_id)
);

-- Recommendations/Testimonials (new)
CREATE TABLE user_recommendations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  recipient_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  recommender_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  testimonial TEXT NOT NULL,
  relation VARCHAR(100), -- 'Rekan Tim', 'Mentor', 'Teman', etc
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(recipient_id, recommender_id)
);
```

### RLS Policies
- Profiles: SELECT public, UPDATE only own
- user_skills: SELECT public, CRUD only own
- user_experiences: SELECT public, CRUD only own
- user_connections: SELECT own connections, INSERT by both parties, UPDATE by recipient
- user_recommendations: SELECT public, INSERT by recommender, DELETE by recipient

---

## 2. DATA MODELS (Dart)

- [ ] `SkillTagModel` (id, userId, skillName)
- [ ] `ExperienceModel` (id, title, organization, startMonth, startYear, endMonth, endYear, isCurrent, description, mediaUrl)
- [ ] `ConnectionModel` (id, userId, connectedUserId, status, createdAt)
- [ ] `RecommendationModel` (id, recipientId, recommenderId, testimonial, relation)
- [ ] `ProfileDetailModel` (extends current profile - add headline, bio, isOpenToJoin, skills, experiences, connections)

---

## 3. REPOSITORY LAYER

### profile_repository.dart
- [ ] `getProfileById(userId)` - fetch full profile + skills + experiences + recommendations
- [ ] `getOwnProfile()` - get current user profile with edit permissions
- [ ] `updateProfileBasic(headline, bio, isOpenToJoin)` - edit basic info
- [ ] `addSkill(skillName)` - add single skill (validate max 5)
- [ ] `removeSkill(skillId)`
- [ ] `getSkills(userId)`

### experience_repository.dart
- [ ] `getExperiences(userId)` - list all experiences
- [ ] `addExperience(ExperienceModel)` - create new
- [ ] `updateExperience(id, ExperienceModel)` - edit
- [ ] `deleteExperience(id)` - remove
- [ ] `uploadExperienceMedia(file)` - upload to Supabase Storage

### connection_repository.dart
- [ ] `sendConnectionRequest(targetUserId)` - create pending connection
- [ ] `acceptConnectionRequest(connectionId)` - update status to 'accepted'
- [ ] `rejectConnectionRequest(connectionId)` - update status to 'rejected'
- [ ] `getConnectionStatus(userId, targetUserId)` - check connection state
- [ ] `getConnections(userId)` - list accepted connections
- [ ] `getPendingRequests(userId)` - list pending requests
- [ ] `getConnectionCount(userId)` - count accepted connections

### recommendation_repository.dart
- [ ] `getRecommendations(userId)` - list testimonials received
- [ ] `addRecommendation(RecommendationModel)` - write testimonial
- [ ] `deleteRecommendation(id)` - remove own recommendation

---

## 4. STATE MANAGEMENT (Riverpod)

### Controllers
- [ ] `ProfileController` (own profile + edit)
- [ ] `PublicProfileController` (view other users)
- [ ] `ExperienceController` (CRUD experiences)
- [ ] `ConnectionController` (manage connections + pending requests)
- [ ] `SkillTagController` (manage skill tags)
- [ ] `RecommendationController` (manage testimonials)

### Providers
```dart
// Own profile
final ownProfileProvider = AsyncNotifierProvider<ProfileNotifier, ProfileDetailModel>

// Public profile view
final publicProfileProvider = FutureProvider.family<ProfileDetailModel, String> // userId param

// Experience list
final userExperiencesProvider = AsyncNotifierProvider<ExperienceNotifier, List<ExperienceModel>>

// Connection status
final connectionStatusProvider = FutureProvider.family<ConnectionModel?, (String userId, String targetId)>

// Pending requests
final pendingConnectionsProvider = AsyncNotifierProvider<PendingConnectionNotifier, List<ConnectionModel>>

// Skills
final userSkillsProvider = AsyncNotifierProvider<SkillNotifier, List<SkillTagModel>>

// Recommendations
final userRecommendationsProvider = FutureProvider.family<List<RecommendationModel>, String> // userId
```

---

## 5. UI SCREENS & COMPONENTS

### Screens
- [ ] **ProfileViewScreen** (current own profile - ALREADY EXISTS, extend with new sections)
- [ ] **PublicProfileScreen** (view other users - NEW)
- [ ] **EditProfileScreen** (edit bio, headline, skills, Open to Join toggle - NEW)
- [ ] **AddExperienceScreen** (form to add/edit experience - NEW)
- [ ] **ConnectionsListScreen** (view all connections - NEW)
- [ ] **PendingConnectionsScreen** (pending requests - NEW)

### Components/Widgets
- [ ] `SkillChipInput` (editable skill chips, max 5 validation)
- [ ] `ExperienceCard` (display single experience in timeline)
- [ ] `ExperienceForm` (form for add/edit - date pickers, text fields, file upload)
- [ ] `RecommendationCard` (testimonial bubble)
- [ ] `ConnectionButton` (send request / accept / reject / connected state)
- [ ] `OpenToJoinFrame` (visual frame around profile photo when active)
- [ ] `RecommendationPopup` (modal to write testimonial)

---

## 6. PHASE 1: FOUNDATION (WEEK 1)

Priority: Database + Models + Basic UI

### Tasks
- [ ] **DB.1** Create migrations for profiles, user_skills, user_experiences, user_connections, user_recommendations
- [ ] **DB.2** Set up RLS policies for all tables
- [ ] **DB.3** Create Storage bucket for experience media (uploads/)

- [ ] **Models.1** Create SkillTagModel, ExperienceModel, ConnectionModel, RecommendationModel
- [ ] **Models.2** Update ProfileDetailModel to include new fields
- [ ] **Models.3** Add fromMap() / toMap() to all models

- [ ] **Repo.1** Create ProfileRepository with basic getters
- [ ] **Repo.2** Create ExperienceRepository (CRUD methods)
- [ ] **Repo.3** Create ConnectionRepository (request, accept, reject)

- [ ] **UI.1** Extend ProfileViewScreen with skills section (read-only mock)
- [ ] **UI.2** Add ExperienceCard widget to display experiences
- [ ] **UI.3** Add RecommendationCard widget

---

## 7. PHASE 2: CRUD & FORMS (WEEK 2)

Priority: Add/edit functionality

### Tasks
- [ ] **Repo.2** Implement experience CRUD in ExperienceRepository
- [ ] **Repo.3** Implement connection logic (send, accept, reject)
- [ ] **Repo.4** Implement recommendation add/delete

- [ ] **Form.1** Build ExperienceForm widget (title, org, dates, description, optional URL)
- [ ] **Form.2** Add date picker for start/end dates
- [ ] **Form.3** Add checkbox "I'm currently here" logic
- [ ] **Form.4** Add file/URL upload for media

- [ ] **Screen.1** Build AddExperienceScreen (modal or full screen)
- [ ] **Screen.2** Build EditProfileScreen (toggle Open to Join, bio input, skill manager)
- [ ] **Screen.3** Wire experience form to submit to API

---

## 8. PHASE 3: PUBLIC PROFILE & CONNECTIONS (WEEK 3)

Priority: View others + connection flow

### Tasks
- [ ] **Screen.4** Build PublicProfileScreen (same layout as own, but no edit buttons)
- [ ] **UI.4** Add ConnectionButton widget (pending/accept/reject/connected states)
- [ ] **UI.5** Add WhatsApp contact button to public profile
- [ ] **UI.6** Add "Write Recommendation" button + modal popup

- [ ] **Repo.5** Implement recommendation add/remove
- [ ] **Screen.5** Build RecommendationPopup modal
- [ ] **Screen.6** Build PendingConnectionsScreen (list + accept/reject buttons)

- [ ] **Nav.1** Add route to public profile from search/mading/home
- [ ] **Nav.2** Add route to connections list from profile

---

## 9. PHASE 4: REFINEMENT (WEEK 4)

Priority: Polish + edge cases + testing

### Tasks
- [ ] **Polish.1** Add OpenToJoinFrame visual (badge/frame around profile photo)
- [ ] **Polish.2** Add loading/error states to all screens
- [ ] **Polish.3** Validate skill max 5 on frontend
- [ ] **Polish.4** Validate experience form required fields
- [ ] **Polish.5** Add confirmation dialogs for delete actions

- [ ] **Error.1** Handle connection request already exists
- [ ] **Error.2** Handle self-connection attempt (block it)
- [ ] **Error.3** Handle permission denied on edit (not own profile)
- [ ] **Error.4** Handle media upload failures

- [ ] **Test.1** Manual test own profile edit
- [ ] **Test.2** Manual test add/edit/delete experience
- [ ] **Test.3** Manual test connection flow (send, accept, reject)
- [ ] **Test.4** Manual test public profile view
- [ ] **Test.5** Manual test add recommendation

---

## 10. FUTURE ENHANCEMENTS (Post-MVP)

- [ ] Search profiles by skill tags
- [ ] Profile view history / profile visits
- [ ] Skill endorsement system
- [ ] Profile completion percentage indicator
- [ ] Export profile as PDF/CV
- [ ] Notification on pending connection requests
- [ ] Block user feature

---

## ESTIMATED EFFORT

| Phase | Duration | Dev Days |
|-------|----------|----------|
| Phase 1: Foundation | 3-4 days | 2-3 |
| Phase 2: CRUD & Forms | 3-4 days | 2-3 |
| Phase 3: Public & Connections | 3-4 days | 2-3 |
| Phase 4: Refinement | 2-3 days | 1.5-2 |
| **Total** | **11-15 days** | **7.5-11** |

Kalau full-time: 2-3 minggu.

---

## DEPENDENCIES & BLOCKERS

- [ ] Profile model finalized (already have basic, need to extend)
- [ ] Supabase admin access to create tables + RLS
- [ ] Date picker library (use `intl` + `flutter_datetime_picker` or `date_range_picker`)
- [ ] File picker library (use `file_picker` or `image_picker`)
- [ ] Supabase Storage configured

---

## NOTES

1. **Connection System:** Bidirectional. User A sends request → User B gets notification → B accepts/rejects → mutual connection.
2. **Skills:** Max 5. Validate on both frontend and backend.
3. **Open to Join Frame:** Visual badge/frame on profile photo - can be a colored border or overlay widget.
4. **Experience Media:** Optional URL link (Google Drive, certificate, news link). Don't require file upload initially; link is easier.
5. **Recommendations:** Public testimonials written by other users. Only recipient can delete their own recommendation.
6. **Profile Privacy:** Own profile = edit mode allowed. Other profiles = view-only + connect/message options.

---

## RISKS

- **Risk 1:** Bidirectional connection might cause sync issues if not careful with state management. **Mitigation:** Use Riverpod refresh on all connection changes.
- **Risk 2:** Form validation complex (dates, max skills, etc.). **Mitigation:** Use form package (flutter_form_builder) if needed.
- **Risk 3:** Database migrations on live data could break. **Mitigation:** Use Supabase migrations file system and test locally first.

---

## SUCCESS CRITERIA

- ✅ User can view own profile with skills, experiences, recommendations
- ✅ User can edit profile (bio, headline, skills, Open to Join toggle)
- ✅ User can add/edit/delete experiences with dates and description
- ✅ User can send connection requests to other users
- ✅ User can accept/reject connection requests
- ✅ User can view other profiles (no edit, can see connect button)
- ✅ User can write recommendation/testimonial for connected users
- ✅ Skill tags max 5 validated
- ✅ Open to Join frame displays visual indicator
- ✅ No bugs on small devices (360px+), responsive layout
