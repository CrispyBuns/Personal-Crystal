Marts:
        table_width 2
	dw CherrygroveMart
	dw CherrygroveMartAfterDex
	dw VioletMart
	dw AzaleaMart
	dw Goldenrod2FMart1
	dw Goldenrod2FMart2
	dw Goldenrod2FMart2Eevee
	dw Goldenrod3FMart
	dw Goldenrod4FMart
	dw Goldenrod5FTMMart
	dw GoldenrodHarborMart
	dw UndergroundMart
	dw EcruteakMart
	dw OlivineMart
	dw CianwoodMart
	dw YellowForestMart
	dw MahoganyMart1
	dw MahoganyMart2
	dw BlackthornMart
	dw IndigoPlateauMart
	dw ViridianMart
	dw PewterMart
	dw MtMoonMart
	dw CeruleanMart
	dw LavenderMart
	dw VermilionMart
	dw Celadon2FMart1
	dw Celadon2FMart2
	dw Celadon3FTMMart
	dw Celadon4FMart
	dw Celadon5FMart1
	dw Celadon5FMart2
	dw SaffronMart
	dw SilphCoMart
	dw FuchsiaMart
	dw ShamoutiMart1
	dw ShamoutiMart1Souvenir
	dw ShamoutiMart2
	dw BattleTowerMart1
	dw BattleTowerMart2
	dw BattleTowerMart3
	dw BattleFactoryMart1
	dw BattleFactoryMart2
	dw BattleFactoryMart3
	assert_table_length NUM_MARTS

CherrygroveMart:
	db 8 ; # items
	db POTION
	db ANTIDOTE
	db PARALYZEHEAL
	db AWAKENING
	db MAX_REVIVE
	db MAX_POTION
	db FULL_RESTORE
	db HYPER_POTION
	db -1

CherrygroveMartAfterDex:
	db 11 ; # items
	db ULTRA_BALL
	db LUXURY_BALL
	db POTION
	db SOOTHE_BELL
	db PARALYZEHEAL
	db LEFTOVERS
	db MAX_REVIVE
	db HYPER_POTION
	db -1

VioletMart:
	db 12 ; # items
	db GREAT_BALL
	db REPEAT_BALL
	db POTION
	db ESCAPE_ROPE
	db ANTIDOTE
	db PARALYZEHEAL
	db AWAKENING
	db X_ATTACK
	db LUCKY_EGG
	db FULL_RESTORE
	db MAX_REVIVE
	db HYPER_POTION
	db -1

AzaleaMart:
	db 10 ; # items
	db MASTER_BALL, 1
	db POTION
	db SUPER_POTION
	db ESCAPE_ROPE
	db REPEL
	db DUSK_STONE
	db PARALYZEHEAL
	db SCOPE_LENS
        db MAX_REVIVE
	db HYPER_POTION
	db -1

Goldenrod2FMart1:
	db 10 ; # items
	db POTION
	db SUPER_POTION
	db QUICK_CLAW
	db PARALYZEHEAL
	db AWAKENING
	db BURN_HEAL
	db ICE_HEAL
	db FULL_HEAL
	db MAX_REVIVE
	db HYPER_POTION
	db -1

Goldenrod2FMart2:
	db 12 ; # items
	db POKE_BALL
	db GREAT_BALL
	db LUXURY_BALL
	db TIMER_BALL
	db QUICK_BALL
	db ESCAPE_ROPE
	db REPEL
	db POKE_DOLL
	db BLUESKY_MAIL
	db MORPH_MAIL
	db MAX_REVIVE
	db HYPER_POTION
	db -1

Goldenrod2FMart2Eevee:
	db 13 ; # items
	db POKE_BALL
	db GREAT_BALL
	db LUXURY_BALL
	db TIMER_BALL
	db QUICK_BALL
	db ESCAPE_ROPE
	db REPEL
	db POKE_DOLL
	db BLUESKY_MAIL
	db MORPH_MAIL
	db EON_MAIL
	db MAX_REVIVE
	db HYPER_POTION
	db -1

Goldenrod3FMart:
Celadon5FMart2:
	db 10 ; # items
	db X_ATTACK
	db X_DEFEND
	db X_SPEED
	db X_SP_ATK
	db X_SP_DEF
	db X_ACCURACY
	db DIRE_HIT
	db GUARD_SPEC
	db MAX_REVIVE
	db HYPER_POTION
	db -1

Goldenrod4FMart:
Celadon5FMart1:
	db 8 ; # items
	db PROTEIN
	db IRON
	db CARBOS
	db CALCIUM
	db ZINC
	db HP_UP
	db MAX_REVIVE
	db HYPER_POTION
	db -1

Goldenrod5FTMMart:
	db 10 ; # items
	dbw TM_PROTECT,       10000
	dbw TM_REFLECT,       10000
	dbw TM_LIGHT_SCREEN,  1000
	dbw TM_SOLAR_BEAM,    25000
	dbw TM_THUNDER,       30000
	dbw TM_FIRE_BLAST,    30000
	dbw TM_BLIZZARD,      30000
	dbw TM_HYPER_BEAM,    50000
	db MAX_REVIVE
	db HYPER_POTION
	db -1

GoldenrodHarborMart:
	db 7 ; # items
	db ETHER
	db ELIXIR
	db MIRROR_HERB
	db DESTINY_KNOT
	db SURF_MAIL
	db MAX_REVIVE
	db HYPER_POTION
	db -1

UndergroundMart:
	db 6 ; # items
	db ENERGYPOWDER
	db ENERGY_ROOT
	db HEAL_POWDER
	db REVIVAL_HERB
	db MAX_REVIVE
	db HYPER_POTION
	db -1

EcruteakMart:
	db 12 ; # items
	db POKE_BALL
	db LEFTOVERS
	db POTION
	db SUPER_POTION
	db MAX_REVIVE
	db PARALYZEHEAL
	db AWAKENING
	db BURN_HEAL
	db ICE_HEAL
	db REVIVE
	db LIFE_ORB
	db HYPER_POTION
	db -1

OlivineMart:
	db 10 ; # items
	db SCOPE_LENS
	db MAX_REVIVE
	db ULTRA_BALL
	db HYPER_POTION
	db ANTIDOTE
	db PARALYZEHEAL
	db AWAKENING
	db ICE_HEAL
	db SUPER_REPEL
	db METAL_COAT
	db -1

CianwoodMart:
	db 6 ; # items
	db POTION
	db SUPER_POTION
	db HYPER_POTION
	db FULL_HEAL
	db REVIVE
	db MAX_REVIVE
	db -1

YellowForestMart:
	db 6 ; # items
	db POKE_BALL
	db REPEL
	db FRESH_WATER
	db FULL_HEAL
	db MAX_REVIVE
	db HYPER_POTION
	db -1

MahoganyMart1:
	db 6 ; # items
	db TINYMUSHROOM
	db SLOWPOKETAIL
	db GREAT_BALL
	db SUPER_POTION
	db MAX_REVIVE
	db HYPER_POTION
	db -1

MahoganyMart2:
	db 11 ; # items
	db RAGECANDYBAR
	db AIR_BALLOON
	db QUICK_CLAW
	db KINGS_ROCK
	db GREAT_BALL
	db SUPER_POTION
	db HYPER_POTION
	db SUPER_REPEL
	db REVIVE
	db FLOWER_MAIL
	db MAX_REVIVE
	db -1

BlackthornMart:
	db 12 ; # items
	db GREAT_BALL
	db ULTRA_BALL
	db DUSK_BALL
	db HYPER_POTION
	db MAX_POTION
	db FULL_HEAL
	db REVIVE
	db MAX_REPEL
	db X_DEFEND
	db X_ATTACK
	db MUSIC_MAIL
	db MAX_REVIVE
	db -1

IndigoPlateauMart:
	db 10 ; # items
	db MAX_REVIVE
	db QUICK_CLAW
	db MAX_ELIXIR
	db MAX_POTION
	db FULL_RESTORE
	db LIFE_ORB
	db FULL_HEAL
        db LEFTOVERS
        db WISE_GLASSES
	db HYPER_POTION
	db -1

ViridianMart:
	db 12 ; # items
	db ULTRA_BALL
	db NET_BALL
	db MAX_POTION
	db FULL_RESTORE
	db PARALYZEHEAL
	db AWAKENING
	db BURN_HEAL
	db FULL_HEAL
	db MAX_REPEL
	db MAX_REVIVE
	db ABILITY_CAP
	db HYPER_POTION
	db -1

PewterMart:
	db 10 ; # items
	db GREAT_BALL
	db DUSK_BALL
	db SUPER_POTION
	db SUPER_REPEL
	db ANTIDOTE
	db PARALYZEHEAL
	db AWAKENING
	db BURN_HEAL
	db MAX_REVIVE
	db HYPER_POTION
	db -1

MtMoonMart:
	db 10 ; # items
	db POKE_DOLL
	db FRESH_WATER
	db SODA_POP
	db LEMONADE
	db REPEL
	db SUPER_REPEL
	db MIRAGE_MAIL
	db PORTRAITMAIL
	db MAX_REVIVE
	db HYPER_POTION
	db -1

CeruleanMart:
	db 12 ; # items
	db GREAT_BALL
	db ULTRA_BALL
	db DIVE_BALL
	db SUPER_POTION
	db SUPER_REPEL
	db FULL_HEAL
	db X_DEFEND
	db X_ATTACK
	db DIRE_HIT
	db ABILITYPATCH
	db MAX_REVIVE
	db HYPER_POTION
	db -1

LavenderMart:
	db 11 ; # items
	db GREAT_BALL
	db HEAL_BALL
	db POTION
	db HYPER_POTION
	db MAX_REPEL
	db ANTIDOTE
	db PARALYZEHEAL
	db AWAKENING
	db BURN_HEAL
	db MAX_REVIVE
	db CLEAR_AMULET
	db -1

VermilionMart:
	db 12 ; # items
	db ULTRA_BALL
	db REPEAT_BALL
	db SUPER_POTION
	db MAX_POTION
	db REVIVE
	db PARALYZEHEAL
	db AWAKENING
	db BURN_HEAL
	db LITEBLUEMAIL
        db ABILITYPATCH
	db MAX_REVIVE
	db HYPER_POTION
	db -1

Celadon2FMart1:
	db 13 ; # items
	db POTION
	db SUPER_POTION
	db MAX_POTION
	db MAX_POTION
	db ANTIDOTE
	db BURN_HEAL
	db ICE_HEAL
	db AWAKENING
	db PARALYZEHEAL
	db FULL_HEAL
	db REVIVE
	db MAX_REVIVE
	db HYPER_POTION
	db -1

Celadon2FMart2:
	db 11 ; # items
	db POKE_BALL
	db GREAT_BALL
	db ULTRA_BALL
	db QUICK_BALL
	db TIMER_BALL
	db ESCAPE_ROPE
	db REPEL
	db SUPER_REPEL
	db MAX_REPEL
	db MAX_REVIVE
	db HYPER_POTION
	db -1

Celadon3FTMMart:
	db 10 ; # items
	dbw TM_SAFEGUARD,     10000
	dbw TM_BULK_UP,       20000
	dbw TM_CALM_MIND,     20000
	dbw TM_SWORDS_DANCE,  20000
	dbw TM_SUNNY_DAY,     40000
	dbw TM_RAIN_DANCE,    40000
	dbw TM_SANDSTORM,     40000
	dbw TM_HAIL,          40000
	db MAX_REVIVE
	db HYPER_POTION
	db -1

Celadon4FMart:
	db 12 ; # items
	db POKE_DOLL
	db FIRE_STONE
	db WATER_STONE
	db THUNDERSTONE
	db LEAF_STONE
	db ICE_STONE
	db LINKING_CORD
	db EXP_SHARE
	db LOVELY_MAIL
	db SURF_MAIL
	db MAX_REVIVE
	db HYPER_POTION
	db -1

SaffronMart:
	db 11 ; # items
	db GREAT_BALL
	db ULTRA_BALL
	db LUXURY_BALL
	db MAX_POTION
	db MAX_POTION
	db FULL_HEAL
	db X_ATTACK
	db X_DEFEND
	db FLOWER_MAIL
	db MAX_REVIVE
	db HYPER_POTION
	db -1

SilphCoMart:
	db 7 ; # items
	db MAX_POTION
	db MAX_REPEL
	db DREAM_BALL
	db UPGRADE
	db DUBIOUS_DISC
	db MAX_REVIVE
	db HYPER_POTION
	db -1

FuchsiaMart:
	db 10 ; # items
	db GREAT_BALL
	db ULTRA_BALL
	db NEST_BALL
	db SUPER_POTION
	db MAX_POTION
	db FULL_HEAL
	db MAX_REPEL
	db FLOWER_MAIL
	db MAX_REVIVE
	db HYPER_POTION
	db -1

ShamoutiMart1:
	db 6 ; # items
	db MENTAL_HERB
	db POWER_HERB
	db WHITE_HERB
	db BIG_ROOT
	db MAX_REVIVE
	db HYPER_POTION
	db -1

ShamoutiMart1Souvenir:
	db 7 ; # items
	db ODD_SOUVENIR
	db MENTAL_HERB
	db POWER_HERB
	db WHITE_HERB
	db BIG_ROOT
	db MAX_REVIVE
	db HYPER_POTION
	db -1

ShamoutiMart2:
	db 8 ; # items
	db DAMP_ROCK
	db HEAT_ROCK
	db SMOOTH_ROCK
	db ICY_ROCK
	db LIGHT_CLAY
	db EVIOLITE
	db MAX_REVIVE
	db HYPER_POTION
	db -1

BattleTowerMart1:
	db 9 ; # items
	db CHOICE_BAND,  48
	db CHOICE_SCARF, 48
	db CHOICE_SPECS, 48
	db EXPERT_BELT,  32
	db MUSCLE_BAND,  32
	db WISE_GLASSES, 32
	db METRONOME_I,  32
	db MAX_REVIVE
	db HYPER_POTION
	db -1

BattleTowerMart2:
	db 11 ; # items
	db RARE_CANDY,   16
	db PP_MAX,       64
	db ABILITY_CAP,  32
	db WEAK_POLICY,  48
	db BLUNDRPOLICY, 48
	db SCOPE_LENS,   16
	db WIDE_LENS,    16
	db ZOOM_LENS,    16
	db BRIGHTPOWDER, 24
	db MAX_REVIVE
	db HYPER_POTION
	db -1

BattleTowerMart3:
	db 9 ; # items
	db MACHO_BRACE,  16
	db POWER_WEIGHT, 24
	db POWER_BRACER, 24
	db POWER_BELT,   24
	db POWER_LENS,   24
	db POWER_BAND,   24
	db POWER_ANKLET, 24
	db MAX_REVIVE
	db HYPER_POTION
	db -1

BattleFactoryMart1:
	db 11 ; # items
	db FOCUS_BAND,   16
	db FOCUS_SASH,   48
	db ASSAULT_VEST, 48
	db PROTECT_PADS, 16
	db ROCKY_HELMET, 48
	db SAFE_GOGGLES, 32
	db HEAVY_BOOTS,  48
	db PUNCHINGLOVE, 16
	db COVERT_CLOAK, 16
	db MAX_REVIVE
	db HYPER_POTION
	db -1

BattleFactoryMart2:
	db 10 ; # items
	db EJECT_BUTTON, 32
	db EJECT_PACK,   32
	db RED_CARD,     24
	db IRON_BALL,    32
	db LAGGING_TAIL, 24
	db FLAME_ORB,    32
	db TOXIC_ORB,    32
	db BLACK_SLUDGE, 32
	db MAX_REVIVE
	db HYPER_POTION
	db -1

BattleFactoryMart3:
	db 10 ; # items
	db CLEAR_AMULET, 16
	db BINDING_BAND, 32
	db GRIP_CLAW,    32
	db LOADED_DICE,  16
	db THROAT_SPRAY, 24
	db ROOM_SERVICE, 24
	db LIFE_ORB,     48
	db MINT_LEAF,    32
	db MAX_REVIVE
	db HYPER_POTION
	db -1
