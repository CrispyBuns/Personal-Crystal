	db  20,  10,  55,  80,  15,  20 ; 200 BST
	;   hp  atk  def  spe  sat  sdf

	db WATER, WATER ; type
	db 255 ; catch rate
	db 50 ; base exp
	db NO_ITEM, NO_ITEM ; held items
	dn GENDER_F25, HATCH_FASTEST ; gender ratio, step cycles to hatch

	abilities_for MAGIKARP, SWIFT_SWIM, SWIFT_SWIM, RATTLED
	db GROWTH_SLOW ; growth rate
	dn EGG_WATER_2, EGG_DRAGON ; egg groups

	ev_yield 2 spe 

	; tm/hm learnset
	tmhm
	; end
