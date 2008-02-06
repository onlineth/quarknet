delete from milestoneset;
delete from propertyvalue;
delete from propertyname; 
delete from permissions;
delete from permissionset; 
delete from logins_groups;
delete from groups_managers;
delete from comment;
delete from milestoneplacement;
delete from groups_projects;
delete from project;
delete from use;
delete from team;
delete from login;
delete from institution;
insert into permissionset (id, name) values (3, 'God_like_Powers');
insert into login (id, fk_permission_set, discriminator, username, password, first_name, last_name, email, is_test_account, is_first_time_logging_in, is_test_required) values (10000, 3, 'Manager', 'hashi', 'ashmizen', 'Hao', 'Zhou', 'ashmizen@gmail.com', 'f', 'f', 'f');   
insert into login (id, fk_permission_set, discriminator, username, password, first_name, last_name, email, is_test_account, is_first_time_logging_in, is_test_required) values (9999, 3, 'Manager', 'neppy', 'blah', 'Paul', 'Nepywoda', 'the_one@neppy.com', 'f', 'f', 'f');   
insert into permissionset (id, name, fk_manager) values (1, 'Student', 10000);
insert into permissionset (id, name, fk_manager) values (2, 'Teacher', 10000);
update permissionset set fk_manager = 10000 where id = 3;
create sequence seq;
alter table permissions alter column id set default nextval('seq');
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Job', 't', 'f', 't', 'f', 'f', 'f', 'f', 1); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Institution', 't', 'f', 't', 'f', 't', 'f', 'f', 1 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'FAQ', 't', 'f', 't', 'f', 't', 'f', 'f', 1 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'News', 't', 'f', 't', 'f', 't', 'f', 'f', 1 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Glossary', 't', 'f', 't', 'f', 't', 'f', 'f', 1 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Feedback', 't', 'f', 'f', 'f', 'f', 'f', 't', 1 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'LogEntry', 't', 'f', 'f', 'f', 'f', 'f', 't', 1 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Comment', 't', 'f', 'f', 'f', 'f', 'f', 't', 1 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Milestone', 't', 'f', 'f', 'f', 'f', 'f', 'f', 1 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Project', 't', 'f', 't', 'f', 't', 'f', 'f', 1 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Login', 't', 't', 'f', 'f', 'f', 'f', 'f', 1 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Group', 't', 'f', 'f', 'f', 'f', 'f', 'f', 1 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'MilestoneSet', 't', 'f', 'f', 'f', 'f', 'f', 'f', 1 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Use', 't', 'f', 'f', 'f', 'f', 'f', 'f', 1 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'PropertyValue', 't', 'f', 'f', 'f', 'f', 'f', 'f', 1 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'PropertyName', 't', 'f', 'f', 'f', 'f', 'f', 'f', 1 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'UserPropertyName', 't', 'f', 'f', 'f', 'f', 'f', 'f', 1 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'MangerPropertyName', 'f', 'f', 'f', 'f', 'f', 'f', 'f', 1 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'ProjectProperty', 't', 'f', 'f', 'f', 'f', 'f', 'f', 1 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Test', 't', 'f', 'f', 'f', 'f', 'f', 'f', 1 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Question', 't', 'f', 'f', 'f', 'f', 'f', 'f', 1 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Choice', 't', 'f', 'f', 'f', 'f', 'f', 'f', 1 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Response', 't', 'f', 'f', 'f', 'f', 'f', 'f', 1 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'ResponseSheet', 't', 'f', 'f', 'f', 'f', 'f', 'f', 1 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Permissions', 't', 'f', 'f', 'f', 'f', 'f', 'f', 1 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Job', 't', 'f', 't', 'f', 'f', 'f', 'f', 2 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Institution', 't', 't', 't', 't', 't', 'f', 'f', 2 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'FAQ', 't', 't', 't', 't', 't', 'f', 'f', 2 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'News', 't', 't', 't', 't', 't', 'f', 'f', 2 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Glossary', 't', 't', 't', 't', 't', 'f', 'f', 2 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Feedback', 't', 'f', 't', 'f', 'f', 'f', 't', 2 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'LogEntry', 't', 'f', 't', 'f', 'f', 'f', 't', 2 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Comment', 't', 'f', 't', 'f', 'f', 'f', 't', 2 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Milestone', 't', 't', 't', 't', 'f', 'f', 'f', 2 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Project', 't', 't', 't', 't', 't', 'f', 'f', 2 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Login', 't', 't', 't', 't', 'f', 'f', 't', 2 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Group', 't', 't', 't', 't', 'f', 'f', 't', 2 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'MilestoneSet', 't', 't', 't', 't', 'f', 'f', 'f', 2 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Use', 't', 'f', 't', 'f', 'f', 'f', 'f', 2 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'PropertyValue', 't', 'f', 't', 'f', 'f', 'f', 'f', 2 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'PropertyName', 't', 'f', 't', 'f', 'f', 'f', 'f', 2 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'UserPropertyName', 't', 'f', 't', 'f', 'f', 'f', 'f', 2 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'MangerPropertyName', 't', 'f', 't', 'f', 'f', 'f', 'f', 2 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'ProjectProperty', 't', 'f', 't', 'f', 'f', 'f', 'f', 2 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Test', 't', 't', 't', 't', 'f', 'f', 't', 2 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Question', 't', 't', 't', 't', 'f', 'f', 't', 2 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Choice', 't', 't', 't', 't', 'f', 'f', 't', 2 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Response', 't', 'f', 't', 'f', 'f', 'f', 'f', 2 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'ResponseSheet', 't', 'f', 't', 'f', 'f', 'f', 'f', 2 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Permissions', 't', 'f', 't', 'f', 'f', 'f', 'f', 2 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Job', 't', 't', 't', 't', 't', 't', 't', 3 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Institution', 't', 't', 't', 't', 't', 't', 't', 3 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'FAQ', 't', 't', 't', 't', 't', 't', 't', 3 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'News', 't', 't', 't', 't', 't', 't', 't', 3 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Glossary', 't', 't', 't', 't', 't', 't', 't', 3 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Feedback', 't', 't', 't', 't', 't', 't', 't', 3 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'LogEntry', 't', 't', 't', 't', 't', 't', 't', 3 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Comment', 't', 't', 't', 't', 't', 't', 't', 3 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Milestone', 't', 't', 't', 't', 't', 't', 't', 3 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Project', 't', 't', 't', 't', 't', 't', 't', 3 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Login', 't', 't', 't', 't', 't', 't', 't', 3 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Group', 't', 't', 't', 't', 't', 't', 't', 3 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'MilestoneSet', 't', 't', 't', 't', 't', 't', 't', 3 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Use', 't', 't', 't', 't', 't', 't', 't', 3 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'PropertyValue', 't', 't', 't', 't', 't', 't', 't', 3 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'PropertyName', 't', 't', 't', 't', 't', 't', 't', 3 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'UserPropertyName', 't', 't', 't', 't', 't', 't', 't', 3 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'MangerPropertyName', 't', 't', 't', 't', 't', 't', 't', 3 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'ProjectProperty', 't', 't', 't', 't', 't', 't', 't', 3 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Test', 't', 't', 't', 't', 't', 't', 't', 3 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Question', 't', 't', 't', 't', 't', 't', 't', 3 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Choice', 't', 't', 't', 't', 't', 't', 't', 3 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Response', 't', 't', 't', 't', 't', 't', 't', 3 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'ResponseSheet', 't', 't', 't', 't', 't', 't', 't', 3 ); 
insert into permissions (object_name, user_read, user_edit, child_read, child_edit, global_read, global_edit, global_create, fk_permission_set) values( 'Permissions', 't', 't', 't', 't', 't', 't', 't', 3 ); 
alter table permissions alter column id drop default;
drop sequence seq;
update research_group set survey = 'f' where survey is null;
delete from research_group where teacher_id is null;
insert into login (id, fk_permission_set, discriminator, username, password, is_test_account, is_first_time_logging_in, is_test_required) select id, 1, role, name, password, 'f', first_time, survey from research_group where teacher_id is not null;
insert into team (id, name) select id, name from research_group where role = 'user' and teacher_id is not null;  
insert into team (id, name) select id, name from research_group where role = 'upload' and teacher_id is not null;  
insert into team (id, name) values (10000, 'Quarknet Teachers');
insert into institution (id, name, city, state, country) select school.id, school.name, city.name, state.name, 'USA' from city, state, school where city.state_id=state.id and school.city_id=city.id;
insert into institution (id, name, country) select school.id, school.name,'USA' from school where school.city_id is null;
insert into use (date_entered, fk_login, id) select date_entered, research_group_id, id from usage where research_group_id=research_group.id and research_group.teacher_id is not null;
update login set discriminator = 'Login' where discriminator = 'user';
update login set discriminator = 'Login' where discriminator = 'upload';
update login set discriminator = 'Manager', fk_permission_set = 2 where discriminator = 'teacher';
insert into project (id, name) select id, name from project9;
insert into groups_projects (fk_group, fk_project) select distinct id, 1 from team; 
insert into milestoneset (id, name) values (1, 'cosmic_default');
insert into comment (id, fk_project, discriminator, name, normal_description,  type, is_read) select id+20000, 1, 'Milestone', keyword, description, type, 't' from keyword;
create sequence seq;
alter table milestoneplacement alter column id set default nextval('seq');
insert into milestoneplacement (section_id, section, fk_milestone_set, fk_milestone) select section_id, section, 1, id+20000 from keyword;
alter table milestoneplacement alter column id drop default;
drop sequence seq;
insert into comment (id, fk_project, discriminator, date_entered, body, fk_login, fk_comment, is_obsolete, is_read) select id+10000, 1, 'LogEntry', date_entered, log_text, research_group_id, keyword_id+20000, 'f', 't' from log;
insert into comment (id, fk_project, discriminator, fk_comment, date_entered, body, is_read) select id, 1, 'Comment', log_id+10000, date_entered, comment, 't' from comment9;
UPDATE login SET fk_institution = teacher.school_id where teacher.id = research_group.teacher_id and research_group.id = login.id and teacher.school_id is not null;
UPDATE login SET email = teacher.email where teacher.id = research_group.teacher_id and research_group.id = login.id and research_group.role = 'teacher';
UPDATE login SET last_name  = substring(teacher.name from position(' ' in teacher.name)+1) where teacher.id = research_group.teacher_id and research_group.id = login.id and research_group.role = 'teacher';
UPDATE login SET first_name  = substring(teacher.name for position(' ' in teacher.name)) where teacher.id = research_group.teacher_id and research_group.id = login.id and research_group.role = 'teacher';
create table temp (user_id integer, teacher_id integer);
insert into temp (user_id, teacher_id) select research_group.id, teacher.id where research_group.teacher_id = teacher.id and research_group.role != 'teacher' and research_group.teacher_id is not null;
insert into logins_groups (fk_login, fk_group) select distinct id, id from research_group where role != 'teacher';
insert into logins_groups (fk_login, fk_group) select id, 10000 from research_group where role = 'teacher';
insert into groups_managers (fk_group, fk_manager) select temp.user_id, research_group.id from temp, research_group where temp.teacher_id=research_group.teacher_id  and research_group.role = 'teacher';
insert into groups_managers (fk_group, fk_manager) values(10000, 10000);
drop table temp;
insert into propertyname (id, name, fk_project, discriminator) values (1, 'QuarknetDetector', 1, 'ManagerPropertyName');
insert into propertyname (id, name, fk_project, discriminator) values (2, 'CanUpload', 1, 'UserPropertyName');
create sequence seq;
alter table propertyvalue alter column id set default nextval('seq');
insert into propertyvalue (value, fk_login, fk_propertyname) select distinct research_group_detectorid.detectorid, groups_managers.fk_manager, 1 where groups_managers.fk_group = research_group_detectorid.research_group_id and research_group_detectorid.detectorid is not null;
insert into propertyvalue (value, fk_login, fk_propertyname) select distinct 'false', id, 2 from research_group where role = 'user'; 
insert into propertyvalue (value, fk_login, fk_propertyname) select distinct 'true', id, 2 from research_group where role != 'user'; 
alter table propertyvalue alter column id drop default;
drop sequence seq;

