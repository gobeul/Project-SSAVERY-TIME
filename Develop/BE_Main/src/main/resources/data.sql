insert into user (user_name, password, user_email, track_code, region_code) values ('admin', '$2a$08$lDnHPz7eUkSi6ao14Twuau08mzhWrL4kyZGGU5xfiGALO/Vxd5DOi', 'kty226@gmail.com', 1, 1);
insert into user (user_name, password, user_email, track_code, region_code ) values ('user', '$2a$08$UkVvwpULis18S19S5pZFn.YHPZt3oaqHZnDwqbCW9pft6uFtkXKDC', 'user@ssafy.com',1, 1);

insert into authority (authority_name) values ('ROLE_USER');
insert into authority (authority_name) values ('ROLE_ADMIN');



insert into user_authority (user_idx, authority_name) values (1, 'ROLE_USER');
insert into user_authority (user_idx, authority_name) values (1, 'ROLE_ADMIN');
insert into user_authority (user_idx, authority_name) values (2, 'ROLE_USER');

insert into attendance(user_idx, attendance_category, attendance_date) values(1, 1, 20220201);
insert into attendance(user_idx, attendance_category, attendance_date) values(1, 1, 20220211);
insert into attendance(user_idx, attendance_category, attendance_date) values(1, 3, 20220221);
insert into attendance(user_idx, attendance_category, attendance_date) values(1, 4, 20220222);
insert into attendance(user_idx, attendance_category, attendance_date) values(1, 1, 20220221);
insert into attendance(user_idx, attendance_category, attendance_date) values(1, 1, 20220222);
insert into attendance(user_idx, attendance_category, attendance_date) values(1, 1, 20220223);
insert into attendance(user_idx, attendance_category, attendance_date) values(1, 1, 20220224);
insert into attendance(user_idx, attendance_category, attendance_date) values(1, 2, 20220222);
insert into attendance(user_idx, attendance_category, attendance_date) values(2, 1, 20220211);
insert into attendance(user_idx, attendance_category, attendance_date) values(2, 2, 20220221);


insert into survey(created_at, category, ended_at, status, survey_title) values(20200101, 1, 20200103, 1, '설문조사')