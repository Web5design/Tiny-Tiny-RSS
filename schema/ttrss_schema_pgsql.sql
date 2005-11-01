drop table ttrss_tags;
drop table ttrss_entries;
drop table ttrss_feeds;

create table ttrss_feeds (id serial not null primary key,
	title varchar(200) not null unique, 
	feed_url varchar(250) unique not null, 
	icon_url varchar(250) not null default '',
	update_interval integer not null default 0,
	last_updated timestamp default null,
	last_error text not null default '');

insert into ttrss_feeds (title,feed_url) values ('Footnotes', 'http://gnomedesktop.org/node/feed');
insert into ttrss_feeds (title,feed_url) values ('Freedesktop.org', 'http://planet.freedesktop.org/rss20.xml');
insert into ttrss_feeds (title,feed_url) values ('Planet Debian', 'http://planet.debian.org/rss20.xml');
insert into ttrss_feeds (title,feed_url) values ('Planet GNOME', 'http://planet.gnome.org/rss20.xml');
insert into ttrss_feeds (title,feed_url) values ('Planet Ubuntu', 'http://planet.ubuntulinux.org/rss20.xml');

insert into ttrss_feeds (title,feed_url) values ('Monologue', 'http://www.go-mono.com/monologue/index.rss');

insert into ttrss_feeds (title,feed_url) values ('Latest Linux Kernel Versions', 
	'http://kernel.org/kdist/rss.xml');

insert into ttrss_feeds (title,feed_url) values ('RPGDot Newsfeed', 
	'http://www.rpgdot.com/team/rss/rss0.xml');

insert into ttrss_feeds (title,feed_url) values ('Digg.com News', 
	'http://digg.com/rss/index.xml');

insert into ttrss_feeds (title,feed_url) values ('Technocrat.net', 
	'http://syndication.technocrat.net/rss');

create table ttrss_entries (id serial not null primary key, 
	feed_id int references ttrss_feeds(id) ON DELETE CASCADE not null, 
	updated timestamp not null, 
	title text not null, 
	guid text not null unique, 
	link text not null, 
	content text not null,
	content_hash varchar(250) not null,
	last_read timestamp,
	marked boolean not null default false,
	date_entered timestamp not null default NOW(),
	no_orig_date boolean not null default false,
	comments varchar(250) not null default '',
	unread boolean not null default true);

drop table ttrss_filters;
drop table ttrss_filter_types;

create table ttrss_filter_types (id integer primary key, 
	name varchar(120) unique not null, 
	description varchar(250) not null unique);

insert into ttrss_filter_types (id,name,description) values (1, 'title', 'Title');
insert into ttrss_filter_types (id,name,description) values (2, 'content', 'Content');
insert into ttrss_filter_types (id,name,description) values (3, 'both', 
	'Title or Content');

create table ttrss_filters (id serial primary key, 
	filter_type integer not null references ttrss_filter_types(id), 
	reg_exp varchar(250) not null,
	description varchar(250) not null default '');

drop table ttrss_labels;

create table ttrss_labels (id serial primary key, 
	sql_exp varchar(250) not null,
	description varchar(250) not null);

insert into ttrss_labels (sql_exp,description) values ('unread = true', 
	'Unread articles');

insert into ttrss_labels (sql_exp,description) values (
	'last_read is null and unread = false', 'Updated articles');

create table ttrss_tags (id serial primary key, 
	tag_name varchar(250) not null,
	post_id integer references ttrss_entries(id) ON DELETE CASCADE not null);

