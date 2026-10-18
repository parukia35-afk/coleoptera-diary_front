use coleoptera_diary;
drop table stag_records;

create table stag_records(
	id integer primary key not null auto_increment,
    genus_id integer not null,
    commonName varchar(30) not null,
    scientificName varchar(50) not null,
    captiveRecord decimal(4,1) not null,
    wildRecord decimal(4,1),
    japaneseName varchar(30) not null,
    recordYear integer not null,
    previousYear integer,
    locality varchar(30) not null default '',
    isTaiwanese bool not null default 0,
    createdAt timestamp not null default current_timestamp,
    updatedAt timestamp not null default current_timestamp on update current_timestamp,
    constraint fk_stag_genus foreign key(genus_id) references genus(id)
		on update restrict
        on delete restrict,
	constraint uq_genus_scientificName_locality unique(genus_id,scientificName,locality)
);

describe stag_records;
show index from stag_records;
select * from stag_records;
TRUNCATE TABLE stag_records;

-- A：基準
INSERT INTO stag_records (genus_id, commonName, scientificName, captiveRecord, japaneseName, recordYear)
VALUES (8, '測試', 'titanus imperialis', 100.0, 'テスト', 2025);

-- B：同屬、同學名、不同產地
INSERT INTO stag_records (genus_id, commonName, scientificName, captiveRecord, japaneseName, recordYear, locality)
VALUES (8, '測試', 'titanus imperialis', 100.0, 'テスト', 2025, '菲律賓');

-- C：與 B 完全相同，再執行一次
INSERT INTO stag_records (genus_id, commonName, scientificName, captiveRecord, japaneseName, recordYear, locality)
VALUES (8, '測試', 'titanus imperialis', 100.0, 'テスト', 2025, '菲律賓');

-- D：與 A 相同（產地都是空字串）
INSERT INTO stag_records (genus_id, commonName, scientificName, captiveRecord, japaneseName, recordYear)
VALUES (8, '測試', 'titanus imperialis', 100.0, 'テスト', 2025);

SELECT id, scientificName, locality, isTaiwanese FROM stag_records;