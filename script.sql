-- Drop tables
drop table Relics_Materials;
drop table LightCones_Materials;
drop table Abilities_Materials;
drop table Characters_Materials;
drop table Characters_Consumables;
drop table Builds_Relics;
drop table Builds_LightCones;
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
drop table CharacterRelations;
drop table LightCones;
drop table LightConeDetails;
drop table Builds;
drop table Characters;

-- Create tables

create table Characters (
                            name varchar2(100) not null,
                            element varchar2(100),
                            rarity number,
                            path varchar2(100),
                            primary key (name)
);

create table Builds (
                        bid number not null,
                        name varchar2(100) unique,
                        playstyle varchar2(100),
                        cid number not null,
                        primary key (bid),
                        foreign key (cid) references CharacterRelations on delete cascade
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

create table Builds_LightCones (
                                   bid number,
                                   cone_id number,
                                   primary key (bid, cone_id),
                                   foreign key (bid) references Builds on delete cascade,
                                   foreign key (cone_id) references LightCones
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

-- Builds
insert into Builds(bid, name, playstyle) values (0, 'Destruction MC DPS', 'Crit DPS');
insert into Builds(bid, name, playstyle) values (1, 'Himeko PF', 'Break Support');
insert into Builds(bid, name, playstyle) values (2, 'Dan Heng Build', 'Speed DPS');
insert into Builds(bid, name, playstyle) values (3, 'Asta Support', 'Speed Support');
insert into Builds(bid, name, playstyle) values (4, 'March build', 'Freeze Tank');


-- Light Cone Details
insert into LightConeDetails(name, rarity, path, effect) values
    ('Something Irreplaceable', 5, 'The Destruction', 'Kinship -- Increases the wearer''s ATK by 24/28/32/36/40%. When the wearer defeats an enemy or is hit, immediately restores HP equal to 8/9/10/11/12% of the wearer''s ATK. At the same time, the wearer''s DMG is increased by 24/28/32/36/40% until the end of their next turn. This effect cannot stack and can only trigger 1 time per turn.');
insert into LightConeDetails(name, rarity, path, effect) values
    ('Moment of Victory', 5, 'The Preservation', 'Verdict -- Increases the wearer''s DEF by 24/28/32/36/40% and Effect Hit Rate by 24/28/32/36/40%. Increases the chance for the wearer to be attacked by enemies. When the wearer is attacked, increase their DEF by an additional 24/28/32/36/40% until the end of the wearer''s turn.');
insert into LightConeDetails(name, rarity, path, effect) values
    ('Swordplay', 4, 'The Hunt', 'Answers of Their Own -- For each time the wearer hits the same target, DMG dealt increases by 8/10/12/14/16%, stacking up to 5 time(s). This effect will be dispelled when the wearer changes targets.');
insert into LightConeDetails(name, rarity, path, effect) values
    ('Night on the Milky Way', 5, 'The Erudition', 'Meteor Swarm -- For every enemy on the field, increases the wearer''s ATK by 9%/10.5%/12%/13.5%/15%, up to 5 stacks. When an enemy is inflicted with Weakness Break, the DMG dealt by the wearer increases by 30%/35%/40%/45%/50% for 1 turn.');
insert into LightConeDetails(name, rarity, path, effect) values
    ('Meshing Cogs', 3, 'The Harmony', 'Fleet Triumph -- After the wearer uses attacks or gets hit, additionally regenerates 4/5/6/7/8 Energy. This effect can only be triggered 1 time per turn.');

-- LightCones
insert into LightCones(cone_id, name) values (0, 'Something Irreplaceable');
insert into LightCones(cone_id, name) values (1, 'Moment of Victory');
insert into LightCones(cone_id, name) values (2, 'Swordplay');
insert into LightCones(cone_id, name) values (3, 'Night on the Milky Way');
insert into LightCones(cone_id, name) values (4, 'Meshing Cogs');

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

-- Stats for March 7th (cid = 1)
insert into Stats(sid, stat_type, stat_value, cid) values (10, 'HP', 1058, 1);
insert into Stats(sid, stat_type, stat_value, cid) values (11, 'Attack', 511, 1);
insert into Stats(sid, stat_type, stat_value, cid) values (12, 'Defense', 573, 1);
insert into Stats(sid, stat_type, stat_value, cid) values (13, 'Speed', 101, 1);
insert into Stats(sid, stat_type, stat_value, cid) values (14, 'Taunt', 150, 1);

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

-- Basic Attacks
insert into Basic(name, cid, damage) values ('Frigid Cold Arrow', 1, '50-110% of ATK');
insert into Basic(name, cid, damage) values ('Farewell Hit', 0, '50-110% of ATK');
insert into Basic(name, cid, damage) values ('Cloudlancer Art: North Wind', 2, '50-110% of ATK');
insert into Basic(name, cid, damage) values ('Sawblade Tuning', 3, '50-110% ATK');
insert into Basic(name, cid, damage) values ('Spectrum Beam', 4, '50-110% of ATK');

-- Skills
insert into Skills(name, cid, duration) values ('The Power of Cuteness', 1, 3);
insert into Skills(name, cid, duration) values ('RIP Home Run', 0, 1);
insert into Skills(name, cid, duration) values ('Cloudlancer Art: Torrent', 2, 2);
insert into Skills(name, cid, duration) values ('Molten Detonation', 3, 1);
insert into Skills(name, cid, duration) values ('Meteor Storm', 4, 1);

-- Ultimates
insert into Ultimates(name, cid, energy_cost) values ('Glacial Cascade', 1, 120);
insert into Ultimates(name, cid, energy_cost) values ('Stardust Ace', 0, 120);
insert into Ultimates(name, cid, energy_cost) values ('Ethereal Dream', 2, 100);
insert into Ultimates(name, cid, energy_cost) values ('Heavenly Flare', 3, 120);
insert into Ultimates(name, cid, energy_cost) values ('Astral Blessing', 4, 120);

-- Talents
insert into Talents(name, cid, trigger_condition, effect) values ('Girl Power', 1, 'After shielded ally is attacked', 'Counterattack');
insert into Talents(name, cid, trigger_condition, effect) values ('Perfect Pickoff', 0, 'Inflict Weakness Break on enemy', 'ATK increases by 10-22%');
insert into Talents(name, cid, trigger_condition, effect) values ('Superiority of Reach', 2, 'Target of ally ability', 'Wind RES PEN increases by 18-39.6%');
insert into Talents(name, cid, trigger_condition, effect) values ('Victory Rush', 3, 'Enemy inflicted with Weakness Break', 'Gains 1 charge.');
insert into Talents(name, cid, trigger_condition, effect) values ('Astrometry', 4, 'Enemy hit. Extra stack if enemy has Fire Weakness', 'Gains 1 stack of Charging');

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

-- RelicDetails
insert into RelicDetails(name, relic_type, set_name) values ('Grand Duke''s Crown of Netherflame', 'Head', 'The Ashblazing Grand Duke');
insert into RelicDetails(name, relic_type, set_name) values ('Champion''s Chest Guard', 'Body', 'Champion of Streetwise Boxing');
insert into RelicDetails(name, relic_type, set_name) values ('Knight''s Iron Boots of Order', 'Feet', 'Knight of Purity Palace');
insert into RelicDetails(name, relic_type, set_name) values ('Sigonia''s Knot of Cyclicality', 'Link Rope', 'Sigonia, the Unclaimed Desolation');
insert into RelicDetails(name, relic_type, set_name) values ('Taikiyan Laser Stadium', 'Planar Sphere', 'Rutilant Arena');

-- Relics 
insert into Relics(rid, relic_level, name, main_stat, rarity) values (0, 10, 'Grand Duke''s Crown of Netherflame', 'HP', 5);
insert into Relics(rid, relic_level, name, main_stat, rarity) values (1, 13, 'Champion''s Chest Guard', 'CRIT DMG', 5);
insert into Relics(rid, relic_level, name, main_stat, rarity) values (2, 1, 'Knight''s Iron Boots of Order', 'ATK%', 3);
insert into Relics(rid, relic_level, name, main_stat, rarity) values (3, 14, 'Sigonia''s Knot of Cyclicality', 'Energy Regen', 4);
insert into Relics(rid, relic_level, name, main_stat, rarity) values (4, 12, 'Taikiyan Laser Stadium', 'HP%', 5);

-- Builds_Relics
insert into Builds_Relics(bid, rid, rec_main, rec_substat) values (1, 0, 'HP', 'CRIT Rate, CRIT DMG, ATK%');
insert into Builds_Relics(bid, rid, rec_main, rec_substat) values (0, 1, 'HP', 'ATK%, CRIT Rate, CRIT DMG, SPD');
insert into Builds_Relics(bid, rid, rec_main, rec_substat) values (4, 2, 'SPD, DEF%', 'Effect Hit Rate, DEF%, SPD, HP%');
insert into Builds_Relics(bid, rid, rec_main, rec_substat) values (1, 3, 'ATK%', 'CRIT Rate, CRIT DMG, SPD');
insert into Builds_Relics(bid, rid, rec_main, rec_substat) values (2, 4, 'ATK%', 'CRIT Rate, CRIT DMG, ATK%, SPD');


-- Builds_LightCones
insert into Builds_LightCones(bid, cone_id) values (0, 0);
insert into Builds_LightCones(bid, cone_id) values (1, 3);
insert into Builds_LightCones(bid, cone_id) values (2, 2);
insert into Builds_LightCones(bid, cone_id) values (3, 4);
insert into Builds_LightCones(bid, cone_id) values (4, 1);

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

-- Abilities_Materials
insert into Abilities_Materials(cid, name, mid) values (0, 'Farewell Hit', 105);
insert into Abilities_Materials(cid, name, mid) values (1, 'Glacial Cascade', 100);
insert into Abilities_Materials(cid, name, mid) values (2, 'Superiority of Reach', 200);
insert into Abilities_Materials(cid, name, mid) values (3, 'Heavenly Flare', 200);
insert into Abilities_Materials(cid, name, mid) values (4, 'Astral Blessing', 100);

-- LightCones_Materials
insert into LightCones_Materials(cone_id, mid) values (1, 11);
insert into LightCones_Materials(cone_id, mid) values (1, 10);
insert into LightCones_Materials(cone_id, mid) values (0, 105);
insert into LightCones_Materials(cone_id, mid) values (2, 0);
insert into LightCones_Materials(cone_id, mid) values (3, 0);
