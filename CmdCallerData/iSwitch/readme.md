
# Fix of ISwitch Button


## iSwitch does not work properly on first run of script



	First click on iSwitch FIRES EVENT OF INIT STATE , NOT OPPOSITE STATE as should be excepted
		( if PRESSED, then FIRES PRESSED, if UNPRESSED, then fires UNPRESSED )

		BUT THIS HAPPEN ONLY IF ISWITCH IS IN INIT STATE
			( if INIT STATE is PRESSED and iSwitch is UNPRESSED, then works normaly  )