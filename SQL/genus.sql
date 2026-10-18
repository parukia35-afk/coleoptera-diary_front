USE coleoptera_diary;
create table genus(
	id int primary key auto_increment,
    name_zh varchar(100) unique not null,
    name_en varchar(100) unique not null,
    description text,
    sort_order int not null
);
describe genus;
insert into	genus
(name_zh, name_en, sort_order)
values('細身赤屬', 'Cyclommatus', 1),
('鋸鍬屬','Prosopocoilus',2),
('鉗鍬屬','Kirchnerius',3),
('前鍬屬','Epidorcus',4),
('叉角屬','Hexarthrius',5),
('鹿角、金剛鹿角、偽鹿角鍬形蟲等屬','Rhaetulus, Rhaetus, Pseudorhaetus',6),
('小鍬(大鍬屬)','Dorcus (Kokuwa)',7),
('大鍬(大鍬屬)','Dorcus (Ookuwa)',8),
('扁鍬(大鍬屬)','Dorcus (Hirata)',9),
('豔鍬屬','Odontolabis',10),
('圓翅屬','Neolucanus',11),
('黃金鬼屬','Allotopus',12),
('深山屬','Lucanus',13),
('肥角屬','Aegus',14),
('其他','Others',15);
select * from genus
order by sort_order;