-- Drop tables
drop table Relics_Materials;
drop table LightCones_Materials;
drop table Abilities_Materials;
drop table Characters_Materials;
drop table Characters_Consumables;
drop table Builds_Relics;
drop table Relics;
drop table RelicDetails;
drop table RelicSet;
drop table Materials;
drop table MaterialDetails;
drop table Consumables;
drop table Talents;
drop table Ultimates;
drop table Skills;
drop table Basic;
drop table Abilities;
drop table Stats;
drop table Builds;
drop table CharacterRelations;
drop table LightCones;
drop table LightConeDetails;
drop table Characters;
drop sequence build_seq;

-- Create tables

create table Characters (
    name varchar2(100) not null,
    element varchar2(100),
    rarity number,
    path varchar2(100),
    primary key (name)
);

create table LightConeDetails (
    name varchar2(100) not null,
    rarity number,
    path varchar2(100),
    effect varchar2(500),
    primary key (name)
);

create table LightCones (
    cone_id number not null,
    name varchar2(100),
    primary key (cone_id),
    foreign key (name) references LightConeDetails on delete cascade
);

create table CharacterRelations (
    cid number not null,
    name varchar2(100) not null,
    cone_id number,
    primary key (cid),
    foreign key (name) references Characters on delete cascade,
    foreign key (cone_id) references LightCones on delete set null
);

create table Builds (
    bid number not null,
    name varchar2(100) unique,
    playstyle varchar2(100),
    cid number not null,
    cone_id number not null,
    primary key (bid),
    foreign key (cid) references CharacterRelations,
    foreign key (cone_id) references LightCones 
);

create sequence build_seq
  start with 1
  increment by 1
  nocache
  nocycle;

create table Stats (
    sid number,
    stat_type varchar2(30),
    stat_value number,
    cid number,
    primary key (sid, cid),
    unique (cid, stat_type),
    foreign key (cid) references CharacterRelations on delete cascade
);


create table Abilities (
    name varchar2(100),
    ability_type varchar2(100),
    ability_level number,
    cid number,
    description varchar2(500),
    primary key (name, cid),
    foreign key (cid) references CharacterRelations on delete cascade
);


create table Basic (
    name varchar2(100),
    cid number,
    damage varchar2(100),
    primary key (name, cid),
    foreign key (name, cid) references Abilities(name, cid) on delete cascade
);


create table Skills (
    name varchar2(100),
    cid number,
    duration number,
    primary key (name, cid),
    foreign key (name, cid) references Abilities(name, cid) on delete cascade
);


create table Ultimates (
    name varchar2(100),
    cid number,
    energy_cost number,
    primary key (name, cid),
    foreign key (name, cid) references Abilities(name, cid) on delete cascade
);


create table Talents (
    name varchar2(100),
    cid number,
    trigger_condition varchar2(100),
    effect varchar2(200),
    primary key (name, cid),
    foreign key (name, cid) references Abilities(name, cid) on delete cascade
);

create table Consumables (
    name varchar2(100) not null,
    consumable_type varchar2(100),
    effect varchar2(500),
    primary key (name)
);

create table MaterialDetails (
    name varchar2(100) not null,
    material_type varchar2(100),
    location varchar2(100),
    rarity number,
    primary key (name)
);

create table Materials (
    mid number not null,
    name varchar2(100) not null,
    primary key (mid),
    foreign key (name) references MaterialDetails on delete cascade
);

create table RelicSet (
    set_name varchar2(100) not null,
    two_pb varchar2(500),
    four_pb varchar2(500),
    primary key (set_name)
);

create table RelicDetails (
    name varchar2(100) not null,
    relic_type varchar2(100),
    set_name varchar2(100) not null,
    primary key (name),
    foreign key (set_name) references RelicSet on delete cascade
);

create table Relics (
    rid number not null,
    relic_level number,
    name varchar2(100) not null,
    main_stat varchar2(30),
    rarity number,
    primary key (rid),
    foreign key (name) references RelicDetails on delete cascade
);

create table Builds_Relics (
    bid number,
    rid number,
    rec_main varchar2(100),
    rec_substat varchar2(100),
    primary key (bid, rid),
    foreign key (bid) references Builds on delete cascade,
    foreign key (rid) references Relics
);


create table Characters_Consumables (
    name varchar2(100),
    cid number,
    primary key (name, cid),
    foreign key (name) references Consumables on delete cascade,
    foreign key (cid) references CharacterRelations on delete cascade
);

create table Characters_Materials (
    cid number,
    mid number,
    primary key (cid, mid),
    foreign key (cid) references CharacterRelations on delete cascade,
    foreign key (mid) references Materials on delete cascade
);

create table Abilities_Materials (
    cid number,
    name varchar2(100),
    mid number,
    primary key (cid, name, mid),
    foreign key (name, cid) references Abilities(name, cid) on delete cascade,
    foreign key (mid) references Materials on delete cascade
);

create table LightCones_Materials (
    cone_id number,
    mid number,
    primary key (cone_id, mid),
    foreign key (cone_id) references LightCones on delete cascade,
    foreign key (mid) references Materials on delete cascade
);

create table Relics_Materials (
    rid number,
    mid number,
    primary key (rid, mid),
    foreign key (rid) references Relics on delete cascade,
    foreign key (mid) references Materials on delete cascade
);

-- Insert Data
-- Characters
insert into Characters(name, element, rarity, path) values ('Trailblazer', 'Physical', 5, 'The Destruction');
insert into Characters(name, element, rarity, path) values ('March 7th', 'Ice', 4, 'The Preservation');
insert into Characters(name, element, rarity, path) values ('Dan Heng', 'Wind', 4, 'The Hunt');
insert into Characters(name, element, rarity, path) values ('Himeko', 'Fire', 5, 'The Erudition');
insert into Characters(name, element, rarity, path) values ('Asta', 'Fire', 4, 'The Harmony');
insert into Characters(name, element, rarity, path) values ('Jingliu', 'Ice', 5, 'The Destruction');
insert into Characters(name, element, rarity, path) values ('Jing Yuan', 'Lightning', 5, 'The Erudition');
insert into Characters(name, element, rarity, path) values ('Luocha', 'Imaginary', 5, 'The Abundance');
insert into Characters(name, element, rarity, path) values ('Clara', 'Physical', 5, 'The Destruction');

-- Light Cone Details
insert into LightConeDetails(name, rarity, path, effect) values
    ('Something Irreplaceable', 5, 'The Destruction', 'Kinship -- Increases the wearer''s ATK by 24%. When the wearer defeats an enemy or is hit, immediately restores HP equal to 8% of the wearer''s ATK. At the same time, the wearer''s DMG is increased by 24% until the end of their next turn. This effect cannot stack and can only trigger 1 time per turn.');
insert into LightConeDetails(name, rarity, path, effect) values
    ('Moment of Victory', 5, 'The Preservation', 'Verdict -- Increases the wearer''s DEF by 24% and Effect Hit Rate by 24%. Increases the chance for the wearer to be attacked by enemies. When the wearer is attacked, increase their DEF by an additional 24% until the end of the wearer''s turn.');
insert into LightConeDetails(name, rarity, path, effect) values
    ('Swordplay', 4, 'The Hunt', 'Answers of Their Own -- For each time the wearer hits the same target, DMG dealt increases by 8%, stacking up to 5 time(s). This effect will be dispelled when the wearer changes targets.');
insert into LightConeDetails(name, rarity, path, effect) values
    ('Night on the Milky Way', 5, 'The Erudition', 'Meteor Swarm -- For every enemy on the field, increases the wearer''s ATK by 9%, up to 5 stacks. When an enemy is inflicted with Weakness Break, the DMG dealt by the wearer increases by 30% for 1 turn.');
insert into LightConeDetails(name, rarity, path, effect) values
    ('Meshing Cogs', 3, 'The Harmony', 'Fleet Triumph -- After the wearer uses attacks or gets hit, additionally regenerates 4 Energy. This effect can only be triggered 1 time per turn.');
insert into LightConeDetails(name, rarity, path, effect) values
    ('Eyes of the Prey', 4, 'The Nihility', 'Self-Confidence -- Increases the wearer''s Effect Hit Rate by 20%. Additionally, increases DoT dealt by the wearer by 24%.');
insert into LightConeDetails(name, rarity, path, effect) values
    ('Fermata', 4, 'The Nihility', 'Semibreve Rest -- Increases the wearer''s Break Effect by 16%, and increases their DMG to enemies afflicted with Shock or Wind Shear by 16%. This also applies to DoT.');
insert into LightConeDetails(name, rarity, path, effect) values
    ('Good Night and Sleep Well', 4, 'The Nihility', 'Toiler -- For every debuff the target enemy has, the DMG dealt by the wearer increases by 12%, stacking up to 3 times. This effect also applies to DoT.');
insert into LightConeDetails(name, rarity, path, effect) values
    ('Geniuses'' Repose', 4, 'The Erudition', 'Each Now Has a Role to Play -- Increases the wearer''s ATK by 16%. When the wearer defeats an enemy, the wearer''s CRIT DMG increases by 24% for 3 turns.');
insert into LightConeDetails(name, rarity, path, effect) values
    ('Before Dawn', 5, 'The Erudition', 'Long Night -- Increases the wearer''s CRIT DMG by 36%. Increases the wearer''s Skill and Ultimate DMG by 18%. After the wearer uses their Skill or Ultimate, they gain Somnus Corpus. Upon triggering a follow-up attack, Somnus Corpus will be consumed and the follow-up attack DMG increases by 48%.');
insert into LightConeDetails(name, rarity, path, effect) values
    ('The Birth of the Self', 4, 'The Erudition', 'Self -- Increases DMG dealt by the wearer''s follow-up attacks by 24%. If the current HP of the target enemy is below 50% of their Max HP, increases DMG dealt by follow-up attacks by an additional 24%.');

-- LightCones
insert into LightCones(cone_id, name) values (0, 'Something Irreplaceable');
insert into LightCones(cone_id, name) values (1, 'Moment of Victory');
insert into LightCones(cone_id, name) values (2, 'Swordplay');
insert into LightCones(cone_id, name) values (3, 'Night on the Milky Way');
insert into LightCones(cone_id, name) values (4, 'Meshing Cogs');
insert into LightCones(cone_id, name) values (5, 'Eyes of the Prey');
insert into LightCones(cone_id, name) values (6, 'Fermata');
insert into LightCones(cone_id, name) values (7, 'Good Night and Sleep Well');
insert into LightCones(cone_id, name) values (8, 'Geniuses'' Repose');
insert into LightCones(cone_id, name) values (9, 'Before Dawn');
insert into LightCones(cone_id, name) values (10, 'The Birth of the Self');
-- CharacterRelations
insert into CharacterRelations(cid, name, cone_id) values
    (0, 'Trailblazer', NULL);
insert into CharacterRelations(cid, name, cone_id) values
    (1, 'March 7th', NULL);
insert into CharacterRelations(cid, name, cone_id) values
    (2, 'Dan Heng', NULL);
insert into CharacterRelations(cid, name, cone_id) values
    (3, 'Himeko', NULL);
insert into CharacterRelations(cid, name, cone_id) values
    (4, 'Asta', NULL);
insert into CharacterRelations(cid, name, cone_id) values
    (5, 'Jingliu', NULL);
insert into CharacterRelations(cid, name, cone_id) values
    (6, 'Jing Yuan', NULL);
insert into CharacterRelations(cid, name, cone_id) values
    (7, 'Luocha', NULL);
insert into CharacterRelations(cid, name, cone_id) values
    (8, 'Clara', NULL);

-- Builds

insert into Builds(bid, name, playstyle, cid, cone_id) values (build_seq.nextval, 'Destruction MC DPS', 'Crit DPS', 0, 0);
insert into Builds(bid, name, playstyle, cid, cone_id) values (build_seq.nextval, 'Himeko PF', 'Break Support', 3, 3);
insert into Builds(bid, name, playstyle, cid, cone_id) values (build_seq.nextval, 'Dan Heng Build', 'Speed DPS', 2, 2);
insert into Builds(bid, name, playstyle, cid, cone_id) values (build_seq.nextval, 'Asta Support', 'Speed Support', 4, 4);
insert into Builds(bid, name, playstyle, cid, cone_id) values (build_seq.nextval, 'March build', 'Freeze Tank', 1, 1);
insert into Builds(bid, name, playstyle, cid, cone_id) values (build_seq.nextval, 'Jingliu Test', 'HP Drain', 5, 2);
insert into Builds(bid, name, playstyle, cid, cone_id) values (build_seq.nextval, 'JY Build 1', 'Playstyle 1', 6, 0);
insert into Builds(bid, name, playstyle, cid, cone_id) values (build_seq.nextval, 'JY Build 2', 'Playstyle 2', 6, 1);
insert into Builds(bid, name, playstyle, cid, cone_id) values (build_seq.nextval, 'JY Build 3', 'Playstyle 3', 6, 2);
insert into Builds(bid, name, playstyle, cid, cone_id) values (build_seq.nextval, 'JY Build 4', 'Playstyle 4', 6, 3);
insert into Builds(bid, name, playstyle, cid, cone_id) values (build_seq.nextval, 'JY Build 5', 'Playstyle 5', 6, 4);
insert into Builds(bid, name, playstyle, cid, cone_id) values (build_seq.nextval, 'JY Build 6', 'Different Relics', 6, 5);
insert into Builds(bid, name, playstyle, cid, cone_id) values (build_seq.nextval, 'JY Build 7', 'Test build', 6, 6);
insert into Builds(bid, name, playstyle, cid, cone_id) values (build_seq.nextval, 'JY Build 8', 'Playstyle 6', 6, 7);
insert into Builds(bid, name, playstyle, cid, cone_id) values (build_seq.nextval, 'JY Build 9', 'SPD Focus', 6, 8);
insert into Builds(bid, name, playstyle, cid, cone_id) values (build_seq.nextval, 'JY Build 10', 'Crit DPS', 6, 9);
insert into Builds(bid, name, playstyle, cid, cone_id) values (build_seq.nextval, 'JY Build 11', 'Crit Focus', 6, 10);
insert into Builds(bid, name, playstyle, cid, cone_id) values (build_seq.nextval, 'Himeko MoC', 'Follow-up DPS', 3, 4);



-- Stats 
insert into Stats(sid, stat_type, stat_value, cid) values (0, 'HP', 1203, 0);
insert into Stats(sid, stat_type, stat_value, cid) values (1, 'Attack', 601, 0);
insert into Stats(sid, stat_type, stat_value, cid) values (2, 'Defense', 388, 0);
insert into Stats(sid, stat_type, stat_value, cid) values (3, 'Speed', 102, 0);

insert into Stats(sid, stat_type, stat_value, cid) values (0, 'HP', 1058, 1);
insert into Stats(sid, stat_type, stat_value, cid) values (1, 'Attack', 511, 1);
insert into Stats(sid, stat_type, stat_value, cid) values (2, 'Defense', 573, 1);
insert into Stats(sid, stat_type, stat_value, cid) values (3, 'Speed', 101, 1);

insert into Stats(sid, stat_type, stat_value, cid) values (0, 'HP', 882, 2);
insert into Stats(sid, stat_type, stat_value, cid) values (1, 'Attack', 546, 2);
insert into Stats(sid, stat_type, stat_value, cid) values (2, 'Defense', 396, 2);
insert into Stats(sid, stat_type, stat_value, cid) values (3, 'Speed', 110, 2);

insert into Stats(sid, stat_type, stat_value, cid) values (0, 'HP', 1047, 3);
insert into Stats(sid, stat_type, stat_value, cid) values (1, 'Attack', 756, 3);
insert into Stats(sid, stat_type, stat_value, cid) values (2, 'Defense', 436, 3);
insert into Stats(sid, stat_type, stat_value, cid) values (3, 'Speed', 96, 3);

insert into Stats(sid, stat_type, stat_value, cid) values (0, 'HP', 1023, 4);
insert into Stats(sid, stat_type, stat_value, cid) values (1, 'Attack', 511, 4);
insert into Stats(sid, stat_type, stat_value, cid) values (2, 'Defense', 463, 4);
insert into Stats(sid, stat_type, stat_value, cid) values (3, 'Speed', 106, 4);

insert into Stats(sid, stat_type, stat_value, cid) values (0, 'HP', 1435, 5);
insert into Stats(sid, stat_type, stat_value, cid) values (1, 'Attack', 679, 5);
insert into Stats(sid, stat_type, stat_value, cid) values (2, 'Defense', 485, 5);
insert into Stats(sid, stat_type, stat_value, cid) values (3, 'Speed', 96, 5);

insert into Stats(sid, stat_type, stat_value, cid) values (0, 'HP', 1164, 6);
insert into Stats(sid, stat_type, stat_value, cid) values (1, 'Attack', 698, 6);
insert into Stats(sid, stat_type, stat_value, cid) values (2, 'Defense', 485, 6);
insert into Stats(sid, stat_type, stat_value, cid) values (3, 'Speed', 99, 6);

insert into Stats(sid, stat_type, stat_value, cid) values (0, 'HP', 1280, 7);
insert into Stats(sid, stat_type, stat_value, cid) values (1, 'Attack', 756, 7);
insert into Stats(sid, stat_type, stat_value, cid) values (2, 'Defense', 363, 7);
insert into Stats(sid, stat_type, stat_value, cid) values (3, 'Speed', 101, 7);

insert into Stats(sid, stat_type, stat_value, cid) values (0, 'HP', 1241, 8);
insert into Stats(sid, stat_type, stat_value, cid) values (1, 'Attack', 737, 8);
insert into Stats(sid, stat_type, stat_value, cid) values (2, 'Defense', 485, 8);
insert into Stats(sid, stat_type, stat_value, cid) values (3, 'Speed', 90, 8);

-- Abilities
insert into Abilities(name, ability_type, ability_level, cid, description) values ('Frigid Cold Arrow', 'Single Target', 3, 1, 'Deals Ice DMG.');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('The Power of Cuteness', 'Defense', 5, 1, 'Provides a single ally with a Shield.');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('Glacial Cascade', 'AoE ATK', 3, 1, 'Deals Ice DMG to all enemies. Hit enemies have a 50% base chance to be Frozen for 1 turn(s). While Frozen, the enemy cannot take action and will receive additional Ice DMG equal to 30% of March 7th''s ATK at the beginning of each turn.');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('Girl Power', 'Single Target', 1, 1, 'Deal Ice DMG after meeting condition. This effect can be triggered 2 time(s) each turn.');

insert into Abilities(name, ability_type, ability_level, cid, description) values ('Farewell Hit', 'Single Target', 6, 0, 'Deals Physical DMG.');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('RIP Home Run', 'Blast', 9, 0, 'Deals Physical DMG.');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('Stardust Ace', 'Enhance', 7, 0, 'Choose between two attack modes to deliver full strike: Single Target/Blast');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('Perfect Pickoff', 'Enhance', 5, 0, 'Enhance ATK. Can stack up to 2 time(s).');

insert into Abilities(name, ability_type, ability_level, cid, description) values ('Cloudlancer Art: North Wind', 'Single Target', 3, 2, 'Deals Wind DMG.');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('Cloudlancer Art: Torrent', 'Single Target', 5, 2, 'Deals Wind DMG. On CRIT hit, 100% base chance to reduce target''s SPD by 12%.');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('Ethereal Dream', 'Single Target', 5, 2, 'Deals Wind DMG. If enemy is slowed, DMG Multipler increases.');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('Superiority of Reach', 'Enhance', 5, 2, 'Enhance Wind RES PEN. Can be triggered after 2 turn(s).');

insert into Abilities(name, ability_type, ability_level, cid, description) values ('Sawblade Tuning', 'Single Target', 10, 3, 'Deals Fire DMG.');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('Molten Detonation', 'Blast', 10, 3, 'Deals Fire DMG.');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('Heavenly Flare', 'AoE', 10, 3, 'Deals Fire DMG. Regenerates 5 extra Energy for each enemy defeated.');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('Victory Rush', 'AoE', 10, 3, 'Consumes 3 charges to perform a follow-up attack.');

insert into Abilities(name, ability_type, ability_level, cid, description) values ('Spectrum Beam', 'Single Target', 2, 4, 'Deals Fire DMG');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('Meteor Storm', 'Bounce', 3, 4, 'Deals Fire DMG. Further deals 4 extra times to random enemy.');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('Astral Blessing', 'Support', 8, 4, 'Increases SPD of all allies');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('Astrometry', 'Support', 9, 4, 'Increases all allies'' ATK for every stack of Charging');

insert into Abilities(name, ability_type, ability_level, cid, description) values ('Lucent Moonglow', 'Single Target', 1, 5, 'Deals Ice DMG.');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('Transcendent Flash', 'Single Target', 3, 5, 'Deals Ice DMG and obtains 1 stack of Syzygy.');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('Moon On Glacial River', 'Blast', 5, 5, 'Deals Ice DMG. Consumes 1 stack of Syzygy and does not consume Skill Points.');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('Precipitous Blossoms, Fleeting as Stellar Dreams', 'Blast', 7, 5, 'Deals Ice DMG. Obtains 1 stack of Syzygy after the attack.');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('Crescent Transmigration', 'Enhance', 5, 5, 'Enters the Spectral Transmigration state with 2 stacks of Syzygy which enables enhanced skill.');

insert into Abilities(name, ability_type, ability_level, cid, description) values ('Glistening Light', 'Single Target', 1, 6, 'Deals Lightning DMG.');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('Rifting Zenith', 'AoE', 3, 6, 'Deals Lightning DMG and increases Lightning-Lord''s Hits Per Action by 2 for the next turn.');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('Lightbringer', 'AoE', 7, 6, 'Deals Lightning DMG and increases Lightning-Lord''s Hits Per Action by 3 for the next turn.');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('Prana Extirpated', 'Enhance', 5, 6, 'Summons Lightning-Lord at the start of the battle. Lightning-Lord has 60 base SPD and 3 Hits Per Action. Its attacks deal Lightning DMG to random enemies. Every time Lightning-Lord''s Hits Per Action increases by 1, its SPD increases by 10. After Lightning-Lord''s action ends, its SPD and Hits Per Action return to base values.');

insert into Abilities(name, ability_type, ability_level, cid, description) values ('Thorns of the Abyss', 'Single Target', 1, 7, 'Deals Imaginary DMG.');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('Prayer of Abyss Flower', 'Heal', 3, 7, 'Restores a single ally''s HP based on ATK.');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('Death Wish', 'AoE', 7, 7, 'Removes 1 buff from all enemies and deals Imaginary DMG.');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('Cycle of Life', 'Enhance', 5, 7, 'When an ally''s HP drops below 50%, Luocha deploys a Field for 2 turns. While the Field is active, any ally that attacks an enemy restores HP.');

insert into Abilities(name, ability_type, ability_level, cid, description) values ('I Want to Help', 'Single Target', 1, 8, 'Deals Physical DMG.');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('Svarog Watches Over You', 'AoE', 3, 8, 'Deals Physical DMG equal and marks them with Mark of Counter.');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('Promise, Not Command', 'Enhance', 7, 8, 'Reduces DMG taken by 15% and increases the chance of being attacked for 2 turns. Enhances Svarog''s Counter, increasing DMG dealt.');
insert into Abilities(name, ability_type, ability_level, cid, description) values ('Because We''re Family', 'Follow up', 5, 8, 'Under enemy attack, Svarog has a 35% fixed chance to launch a Counter, dealing Physical DMG.');


-- Basic Attacks
insert into Basic(name, cid, damage) values ('Frigid Cold Arrow', 1, '50-110% of ATK');
insert into Basic(name, cid, damage) values ('Farewell Hit', 0, '50-110% of ATK');
insert into Basic(name, cid, damage) values ('Cloudlancer Art: North Wind', 2, '50-110% of ATK');
insert into Basic(name, cid, damage) values ('Sawblade Tuning', 3, '50-110% ATK');
insert into Basic(name, cid, damage) values ('Spectrum Beam', 4, '50-110% of ATK');
insert into Basic(name, cid, damage) values ('Lucent Moonglow', 5, '50-110% of ATK');
insert into Basic(name, cid, damage) values ('Glistening Light', 6, '50-110% of ATK');
insert into Basic(name, cid, damage) values ('Thorns of the Abyss', 7, '50-110% of ATK');
insert into Basic(name, cid, damage) values ('I Want to Help', 8, '50-110% of ATK');


-- Skills
insert into Skills(name, cid, duration) values ('The Power of Cuteness', 1, 3);
insert into Skills(name, cid, duration) values ('RIP Home Run', 0, 1);
insert into Skills(name, cid, duration) values ('Cloudlancer Art: Torrent', 2, 2);
insert into Skills(name, cid, duration) values ('Molten Detonation', 3, 1);
insert into Skills(name, cid, duration) values ('Meteor Storm', 4, 1);
insert into Skills(name, cid, duration) values ('Transcendent Flash', 5, 1);
insert into Skills(name, cid, duration) values ('Moon On Glacial River', 5, 1);
insert into Skills(name, cid, duration) values ('Rifting Zenith', 6, 1);
insert into Skills(name, cid, duration) values ('Prayer of Abyss Flower', 7, 1);
insert into Skills(name, cid, duration) values ('Svarog Watches Over You', 8, 1);


-- Ultimates
insert into Ultimates(name, cid, energy_cost) values ('Glacial Cascade', 1, 120);
insert into Ultimates(name, cid, energy_cost) values ('Stardust Ace', 0, 120);
insert into Ultimates(name, cid, energy_cost) values ('Ethereal Dream', 2, 100);
insert into Ultimates(name, cid, energy_cost) values ('Heavenly Flare', 3, 120);
insert into Ultimates(name, cid, energy_cost) values ('Astral Blessing', 4, 120);
insert into Ultimates(name, cid, energy_cost) values ('Precipitous Blossoms, Fleeting as Stellar Dreams', 5, 140);
insert into Ultimates(name, cid, energy_cost) values ('Lightbringer', 6, 130);
insert into Ultimates(name, cid, energy_cost) values ('Death Wish', 7, 120);
insert into Ultimates(name, cid, energy_cost) values ('Promise, Not Command', 8, 110);


-- Talents
insert into Talents(name, cid, trigger_condition, effect) values ('Girl Power', 1, 'After shielded ally is attacked', 'Counterattack');
insert into Talents(name, cid, trigger_condition, effect) values ('Perfect Pickoff', 0, 'Inflict Weakness Break on enemy', 'ATK increases by 10-22%');
insert into Talents(name, cid, trigger_condition, effect) values ('Superiority of Reach', 2, 'Target of ally ability', 'Wind RES PEN increases by 18-39.6%');
insert into Talents(name, cid, trigger_condition, effect) values ('Victory Rush', 3, 'Enemy inflicted with Weakness Break', 'Gains 1 charge.');
insert into Talents(name, cid, trigger_condition, effect) values ('Astrometry', 4, 'Enemy hit. Extra stack if enemy has Fire Weakness', 'Gains 1 stack of Charging');
insert into Talents(name, cid, trigger_condition, effect) values ('Crescent Transmigration', 5, 'Obtains 2 stacks of Syzygy', 'Enters Spectral Transmigration state, advancing action by 100% and increasing CRIT Rate by 40%. Skill changes to Moon On Glacial River.');
insert into Talents(name, cid, trigger_condition, effect) values ('Prana Extirpated', 6, 'Start of battle', 'Summons Lightning-Lord with 60 SPD and 3 Hits Per Action.');
insert into Talents(name, cid, trigger_condition, effect) values ('Cycle of Life', 7, 'Ally HP drops below 50%', 'Deploys a Field for 2 turns; allies attacking an enemy restore HP.');
insert into Talents(name, cid, trigger_condition, effect) values ('Because We''re Family', 8, 'When hit by enemy attacks', 'DMG taken reduced by 10%; Svarog marks attacker with Mark of Counter and retaliates with a Counter dealing Physical DMG.');


-- Consumables
insert into Consumables(name, consumable_type, effect) values
    ('Alfalfa Salad', 'Attack', 'Increases all allies'' CRIT Rate by 18% for the next battle.');
insert into Consumables(name, consumable_type, effect) values
    ('All Good Potion', 'Energy Regen', 'Immediately regenerates 50% of Max Energy for a single ally.');
insert into Consumables(name, consumable_type, effect) values
    ('Amber Huadiao Wine', 'Defense', 'Immediately causes all allies to lose HP equal to 5% of their Max HP, and increases their Max HP by 24% for the next battle.');
insert into Consumables(name, consumable_type, effect) values
    ('Berrypheasant Skewers', 'Restorative', 'Immediately heals one ally by 15% of the ally''s Max HP plus 150 extra HP.');
insert into Consumables(name, consumable_type, effect) values
    ('Camo Paint', 'Special', 'Enemies will be less likely to detect your team for 75s.');

-- MaterialDetails
insert into MaterialDetails(name, material_type, location, rarity) values ('Destroyer''s Final Road', 'Trace', 'Herta Space Station', 4);
insert into MaterialDetails(name, material_type, location, rarity) values ('Endotherm Chitin', 'Ascension', 'Jarilo-VI', 4);
insert into MaterialDetails(name, material_type, location, rarity) values ('Sparse Aether', 'EXP', 'All Locations', 2);
insert into MaterialDetails(name, material_type, location, rarity) values ('Oath of Steel', 'Ascension', 'Herta Space Station', 3);
insert into MaterialDetails(name, material_type, location, rarity) values ('Tracks of Destiny', 'Trace', 'Event rewards', 5);
insert into MaterialDetails(name, material_type, location, rarity) values ('Lost Gold Fragment', 'Relic', 'Relic Salvage, Rewards', 3);
insert into MaterialDetails(name, material_type, location, rarity) values ('Silvermane Badge', 'Ascension', 'Jarilo-VI', 2);
insert into MaterialDetails(name, material_type, location, rarity) values ('Squirming Core', 'Ascension, Trace', 'Jarilo-VI', 4);
insert into MaterialDetails(name, material_type, location, rarity) values ('Usurper''s Scheme', 'Ascension, Trace', 'Herta Space Station', 3);
insert into MaterialDetails(name, material_type, location, rarity) values ('Lifeless Blade', 'Trace, Light Cone Ascension', 'Herta Space Station', 3);
insert into MaterialDetails(name, material_type, location, rarity) values ('Lost Crystal', 'Relic', 'Relic Salvage, Rewards', 4);
insert into MaterialDetails(name, material_type, location, rarity) values ('Extinguished Core', 'Ascension', 'Enemy Drops', 2);
insert into MaterialDetails(name, material_type, location, rarity) values ('Glimmering Core', 'Ascension', 'Enemy Drops', 3);
insert into MaterialDetails(name, material_type, location, rarity) values ('Traveler''s Guide', 'EXP', 'All Locations', 3);
insert into MaterialDetails(name, material_type, location, rarity) values ('Condensed Aether', 'EXP', 'All Locations', 3);


-- Materials
insert into Materials(mid, name) values (200, 'Destroyer''s Final Road');
insert into Materials(mid, name) values (30, 'Endotherm Chitin');
insert into Materials(mid, name) values (0, 'Sparse Aether');
insert into Materials(mid, name) values (11, 'Oath of Steel');
insert into Materials(mid, name) values (100, 'Tracks of Destiny');
insert into Materials(mid, name) values (5, 'Lost Gold Fragment');
insert into Materials(mid, name) values (10, 'Silvermane Badge');
insert into Materials(mid, name) values (6, 'Squirming Core');
insert into Materials(mid, name) values (104, 'Usurper''s Scheme');
insert into Materials(mid, name) values (105, 'Lifeless Blade');
insert into Materials(mid, name) values (106, 'Lost Crystal');
insert into Materials(mid, name) values (201, 'Extinguished Core');
insert into Materials(mid, name) values (202, 'Glimmering Core');
insert into Materials(mid, name) values (203, 'Traveler''s Guide');
insert into Materials(mid, name) values (204, 'Condensed Aether');

-- Relic Sets
insert into RelicSet(set_name, two_pb, four_pb) values
    ('The Ashblazing Grand Duke', 'Increases the DMG dealt by follow-up attacks by 20%.', 'When the wearer uses follow-up attacks, increases the wearer''s ATK by 6% for every time the follow-up attack deals DMG. This effect can stack up to 8 time(s) and lasts for 3 turn(s). This effect is removed the next time the wearer uses a follow-up attack.');
insert into RelicSet(set_name, two_pb, four_pb) values
    ('Champion of Streetwise Boxing', 'Increases Physical DMG by 10%.', 'After the wearer attacks or is hit, their ATK increases by 5% for the rest of the battle. This effect can stack up to 5 time(s).');
insert into RelicSet(set_name, two_pb, four_pb) values
    ('Knight of Purity Palace', 'Increases DEF by 15%.', 'Increases the max DMG that can be absorbed by the Shield created by the wearer by 20%.');
insert into RelicSet(set_name, two_pb, four_pb) values
    ('Sigonia, the Unclaimed Desolation', 'Increases the wearer''s CRIT Rate by 4%. When an enemy target gets defeated, the wearer''s CRIT DMG increases by 4%, stacking up to 10 time(s).', NULL);
insert into RelicSet(set_name, two_pb, four_pb) values
    ('Rutilant Arena', 'Increases the wearer''s CRIT Rate by 8%. When the wearer''s current CRIT Rate reaches 70% or higher, the wearer''s Basic ATK and Skill DMG increase by 20%.', NULL);
insert into RelicSet(set_name, two_pb, four_pb) values (
    'Musketeer of Wild Wheat', 'ATK increases by 12%.', 'The wearer''s SPD increases by 6% and Basic ATK DMG increases by 10%.');
insert into RelicSet(set_name, two_pb, four_pb) values (
    'Firesmith of Lava-Forging','Increases Fire DMG by 10%.', 'Increases the wearer''s Skill DMG by 12%. After using Ultimate, increases the wearer''s Fire DMG by 12% for the next attack.');
insert into RelicSet(set_name, two_pb, four_pb) values (
    'Genius of Brilliant Stars','Increases Quantum DMG by 10%.','When the wearer deals DMG to the target enemy, ignores 10% DEF. If the target enemy has Quantum Weakness, the wearer additionally ignores 10% DEF.');
insert into RelicSet(set_name, two_pb, four_pb) values (
    'Band of Sizzling Thunder', 'Increases Lightning DMG by 10%.', 'When the wearer uses Skill, increases the wearer''s ATK by 20% for  turn(s).');
insert into RelicSet(set_name, two_pb, four_pb) values (
    'Eagle of Twilight Line', 'Increases Wind DMG by 10%.','After the wearer uses their Ultimate, their action is Advanced Forward by 25%.');
insert into RelicSet(set_name, two_pb, four_pb) values (
    'Thief of Shooting Meteor', 'Increases Break Effect by 16%.', 'Increases the wearer''s Break Effect by 16%. After the wearer inflicts Weakness Break on an enemy, regenerates 3 Energy.');
insert into RelicSet (set_name, two_pb, four_pb) values (
    'Inert Salsotto','Increases the wearer''s CRIT Rate by 8%. When the wearer''s current CRIT Rate reaches 50% or higher, the wearer''s Ultimate and follow-up attack DMG increases by 15%.', NULL);
insert into RelicSet (set_name, two_pb, four_pb) values (
    'Pan-Cosmic Commercial Enterprise', 'Increases the wearer''s Effect Hit Rate by 10%. Meanwhile, the wearer''s ATK increases by an amount equal to 25% of the current Effect Hit Rate, up to a maximum of 25%.', NULL);
insert into RelicSet (set_name, two_pb, four_pb) values (
    'Celestial Differentiator', 'Increases the wearer''s CRIT DMG by 16%. When the wearer''s current CRIT DMG reaches 120% or higher, after entering battle, the wearer''s CRIT Rate increases by 60% until the end of their first attack.', NULL);
insert into RelicSet (set_name, two_pb, four_pb) values (
    'Belobog of the Architects', 'Increases the wearer''s DEF by 15%. When the wearer''s Effect Hit Rate is 50% or higher, the wearer gains an extra 15% DEF.', NULL);

-- RelicDetails
insert into RelicDetails(name, relic_type, set_name) values ('Grand Duke''s Crown of Netherflame', 'Head', 'The Ashblazing Grand Duke');
insert into RelicDetails(name, relic_type, set_name) values ('Champion''s Chest Guard', 'Body', 'Champion of Streetwise Boxing');
insert into RelicDetails(name, relic_type, set_name) values ('Knight''s Iron Boots of Order', 'Feet', 'Knight of Purity Palace');
insert into RelicDetails(name, relic_type, set_name) values ('Sigonia''s Knot of Cyclicality', 'Link Rope', 'Sigonia, the Unclaimed Desolation');
insert into RelicDetails(name, relic_type, set_name) values ('Taikiyan Laser Stadium', 'Planar Sphere', 'Rutilant Arena');
insert into RelicDetails(name, relic_type, set_name) values ('Musketeer''s Coarse Leather Gloves', 'Hand', 'Musketeer of Wild Wheat');

insert into RelicDetails (name, relic_type, set_name) values ('Firesmith''s Fireproof Apron', 'Head', 'Firesmith of Lava-Forging');
insert into RelicDetails (name, relic_type, set_name) values ('Firesmith''s Alloy Leg', 'Hand', 'Firesmith of Lava-Forging');
insert into RelicDetails (name, relic_type, set_name) values ('Firesmith''s Smelting Gear', 'Body', 'Firesmith of Lava-Forging');
insert into RelicDetails (name, relic_type, set_name) values ('Firesmith''s Obsidian Goggles', 'Feet', 'Firesmith of Lava-Forging');

insert into RelicDetails (name, relic_type, set_name) values ('Genius''s Metafield Suit', 'Head', 'Genius of Brilliant Stars');
insert into RelicDetails (name, relic_type, set_name) values ('Genius''s Microdimensional Gloves', 'Hand', 'Genius of Brilliant Stars');
insert into RelicDetails (name, relic_type, set_name) values ('Genius''s Quantum Paradox', 'Body', 'Genius of Brilliant Stars');
insert into RelicDetails (name, relic_type, set_name) values ('Genius''s Hyperspace Shoes', 'Feet', 'Genius of Brilliant Stars');

insert into RelicDetails (name, relic_type, set_name) values ('Band Singer''s Stage Mask', 'Head', 'Band of Sizzling Thunder');
insert into RelicDetails (name, relic_type, set_name) values ('Band Singer''s Leather Gloves', 'Hand', 'Band of Sizzling Thunder');
insert into RelicDetails (name, relic_type, set_name) values ('Band Singer''s Performance Suit', 'Body', 'Band of Sizzling Thunder');
insert into RelicDetails (name, relic_type, set_name) values ('Band Singer''s Dance Shoes', 'Feet', 'Band of Sizzling Thunder');

insert into RelicDetails (name, relic_type, set_name) values ('Eagle''s Soaring Helmet', 'Head', 'Eagle of Twilight Line');
insert into RelicDetails (name, relic_type, set_name) values ('Eagle''s Winged Gloves', 'Hand', 'Eagle of Twilight Line');
insert into RelicDetails (name, relic_type, set_name) values ('Eagle''s Feathered Cape', 'Body', 'Eagle of Twilight Line');
insert into RelicDetails (name, relic_type, set_name) values ('Eagle''s Talon Boots', 'Feet', 'Eagle of Twilight Line');

insert into RelicDetails (name, relic_type, set_name) values ('Thief''s Myriad-Faced Mask', 'Head', 'Thief of Shooting Meteor');
insert into RelicDetails (name, relic_type, set_name) values ('Thief''s Gloves With Prints', 'Hand', 'Thief of Shooting Meteor');
insert into RelicDetails (name, relic_type, set_name) values ('Thief''s Steel Grappling Hook', 'Body', 'Thief of Shooting Meteor');
insert into RelicDetails (name, relic_type, set_name) values ('Thief''s Meteor Boots', 'Feet', 'Thief of Shooting Meteor');

insert into RelicDetails (name, relic_type, set_name) values ('Salsotto''s Moving City', 'Planar Sphere', 'Inert Salsotto');
insert into RelicDetails (name, relic_type, set_name) values ('Salsotto''s Terminator Line', 'Link Rope', 'Inert Salsotto');

insert into RelicDetails (name, relic_type, set_name) values ('Pan-Cosmic Business Strategy', 'Planar Sphere', 'Pan-Cosmic Commercial Enterprise');
insert into RelicDetails (name, relic_type, set_name) values ('Pan-Cosmic Trade Route', 'Link Rope', 'Pan-Cosmic Commercial Enterprise');

insert into RelicDetails (name, relic_type, set_name) values ('Celestial Differentiator Planar Sphere', 'Planar Sphere', 'Celestial Differentiator');
insert into RelicDetails (name, relic_type, set_name) values ('Celestial Differentiator Link Rope', 'Link Rope', 'Celestial Differentiator');

insert into RelicDetails (name, relic_type, set_name) values ('Belobog''s Fortress of Preservation', 'Planar Sphere', 'Belobog of the Architects');
insert into RelicDetails (name, relic_type, set_name) values ('Belobog''s Constructive Blueprint', 'Link Rope', 'Belobog of the Architects');


-- Relics 
insert into Relics(rid, relic_level, name, main_stat, rarity) values (0, 10, 'Grand Duke''s Crown of Netherflame', 'HP', 5);
insert into Relics(rid, relic_level, name, main_stat, rarity) values (1, 13, 'Champion''s Chest Guard', 'CRIT DMG', 5);
insert into Relics(rid, relic_level, name, main_stat, rarity) values (2, 1, 'Knight''s Iron Boots of Order', 'ATK%', 3);
insert into Relics(rid, relic_level, name, main_stat, rarity) values (3, 14, 'Sigonia''s Knot of Cyclicality', 'Energy Regen', 4);
insert into Relics(rid, relic_level, name, main_stat, rarity) values (4, 12, 'Taikiyan Laser Stadium', 'HP%', 5);
insert into Relics(rid, relic_level, name, main_stat, rarity) values (5, 12, 'Musketeer''s Coarse Leather Gloves', 'ATK%', 4);

insert into Relics (rid, relic_level, name, main_stat, rarity) values (6, 15, 'Firesmith''s Fireproof Apron', 'HP', 5);
insert into Relics (rid, relic_level, name, main_stat, rarity) values (7, 12, 'Firesmith''s Alloy Leg', 'ATK%', 4);
insert into Relics (rid, relic_level, name, main_stat, rarity) values (8, 10, 'Firesmith''s Smelting Gear', 'DEF', 3);
insert into Relics (rid, relic_level, name, main_stat, rarity) values (9, 13, 'Firesmith''s Obsidian Goggles', 'SPD', 5);

insert into Relics (rid, relic_level, name, main_stat, rarity) values (10, 14, 'Genius''s Metafield Suit', 'HP', 5);
insert into Relics (rid, relic_level, name, main_stat, rarity) values (11, 11, 'Genius''s Microdimensional Gloves', 'ATK', 4);
insert into Relics (rid, relic_level, name, main_stat, rarity) values (12, 13, 'Genius''s Quantum Paradox', 'DEF%', 5);
insert into Relics (rid, relic_level, name, main_stat, rarity)  values (13, 12, 'Genius''s Hyperspace Shoes', 'SPD', 4);

insert into Relics (rid, relic_level, name, main_stat, rarity) values (18, 15, 'Salsotto''s Moving City', 'CRIT Rate%', 5);
insert into Relics (rid, relic_level, name, main_stat, rarity) values (19, 15, 'Salsotto''s Terminator Line', 'CRIT DMG%', 5);

insert into Relics (rid, relic_level, name, main_stat, rarity) values (20, 15, 'Pan-Cosmic Business Strategy', 'Effect Hit Rate%', 5);
insert into Relics (rid, relic_level, name, main_stat, rarity) values (21, 15, 'Pan-Cosmic Trade Route', 'ATK%', 5);

insert into Relics (rid, relic_level, name, main_stat, rarity) values (22, 15, 'Celestial Differentiator Planar Sphere', 'CRIT DMG%', 5);
insert into Relics (rid, relic_level, name, main_stat, rarity) values (23, 15, 'Celestial Differentiator Link Rope', 'CRIT Rate%', 5);

insert into Relics (rid, relic_level, name, main_stat, rarity) values (24, 15, 'Belobog''s Fortress of Preservation', 'DEF%', 5);
insert into Relics (rid, relic_level, name, main_stat, rarity) values (25, 15, 'Belobog''s Constructive Blueprint', 'Effect Hit Rate%', 5);


-- Builds_Relics
insert into Builds_Relics(bid, rid, rec_main, rec_substat) values (1, 0, 'HP', 'CRIT Rate, CRIT DMG, ATK%');
insert into Builds_Relics(bid, rid, rec_main, rec_substat) values (5, 1, 'HP', 'ATK%, CRIT Rate, CRIT DMG, SPD');
insert into Builds_Relics(bid, rid, rec_main, rec_substat) values (4, 2, 'SPD, DEF%', 'Effect Hit Rate, DEF%, SPD, HP%');
insert into Builds_Relics(bid, rid, rec_main, rec_substat) values (1, 3, 'ATK%', 'CRIT Rate, CRIT DMG, SPD');
insert into Builds_Relics(bid, rid, rec_main, rec_substat) values (2, 4, 'ATK%', 'CRIT Rate, CRIT DMG, ATK%, SPD');

-- Characters_Consumables
insert into Characters_Consumables(name, cid) values ('Alfalfa Salad', 0);
insert into Characters_Consumables(name, cid) values ('Amber Huadiao Wine', 1);
insert into Characters_Consumables(name, cid) values ('Alfalfa Salad', 2);
insert into Characters_Consumables(name, cid) values ('Camo Paint', 3);
insert into Characters_Consumables(name, cid) values ('All Good Potion', 3);

-- Characters_Materials
insert into Characters_Materials(cid, mid) values (0, 104);
insert into Characters_Materials(cid, mid) values (1, 11);
insert into Characters_Materials(cid, mid) values (2, 6);
insert into Characters_Materials(cid, mid) values (3, 30);
insert into Characters_Materials(cid, mid) values (4, 30);
insert into Characters_Materials (cid, mid) values (4, 104); 

insert into Characters_Materials (cid, mid) values (5, 201); 
insert into Characters_Materials (cid, mid) values (5, 202); 
insert into Characters_Materials (cid, mid) values (5, 6);   

insert into Characters_Materials (cid, mid) values (6, 10);  
insert into Characters_Materials (cid, mid) values (6, 11); 
insert into Characters_Materials (cid, mid) values (6, 30);  

insert into Characters_Materials (cid, mid) values (7, 5);  
insert into Characters_Materials (cid, mid) values (7, 6); 
insert into Characters_Materials (cid, mid) values (7, 104);

insert into Characters_Materials (cid, mid) values (8, 105);

-- Abilities_Materials
insert into Abilities_Materials(cid, name, mid) values (0, 'Farewell Hit', 105);
insert into Abilities_Materials(cid, name, mid) values (1, 'Glacial Cascade', 100);
insert into Abilities_Materials(cid, name, mid) values (2, 'Superiority of Reach', 200);
insert into Abilities_Materials(cid, name, mid) values (3, 'Heavenly Flare', 200);
insert into Abilities_Materials(cid, name, mid) values (4, 'Astral Blessing', 100);
insert into Abilities_Materials (cid, name, mid) values (5, 'Lucent Moonglow', 105);
insert into Abilities_Materials (cid, name, mid) values (6, 'Lightbringer', 200);
insert into Abilities_Materials (cid, name, mid) values (7, 'Cycle of Life', 100);
insert into Abilities_Materials (cid, name, mid) values (8, 'Promise, Not Command', 105);

-- LightCones_Materials
insert into LightCones_Materials(cone_id, mid) values (1, 11);
insert into LightCones_Materials(cone_id, mid) values (1, 10);
insert into LightCones_Materials(cone_id, mid) values (0, 105);
insert into LightCones_Materials(cone_id, mid) values (2, 0);
insert into LightCones_Materials(cone_id, mid) values (3, 0);

-- Relics_Materials
insert into Relics_Materials(rid, mid) values (0, 5);
insert into Relics_Materials(rid, mid) values (1, 5);
insert into Relics_Materials(rid, mid) values (1, 106);
insert into Relics_Materials(rid, mid) values (2, 5);
insert into Relics_Materials(rid, mid) values (3, 106);
insert into Relics_Materials(rid, mid) values (4, 5);

