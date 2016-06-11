{
	'chapter' : u"//*[((name()='h1' or name()='h2' or name()='h4') and re:test(., '\\s*((chapter|book|section|part)\\s+)|((prolog|prologue|epilogue)(\\s+|$))', 'i')) or @class = 'chapter']",
	'remove_first_image' : False,
	'insert_metadata' : False,
	'chapter_mark' : u'pagebreak',
	'remove_fake_margins' : True,
	'start_reading_at' : None,
	'page_breaks_before' : u"//*[name()='h1' or name()='h2' or name()='h4']",
}