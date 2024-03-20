#include <Array.au3>
#include <File.au3>

HotKeySet('{esc}', '_Exit')

Local $aPrompts[5][7]

; Coalforge Collective
$aPrompts[0][0] = "Coalforge Collective - Ace: In a steampunk world, depict The Supreme Engineer, a stern, burly man with jet black hair, in the heart of a roaring coal forge. Around him, coal miners and blacksmiths, decked in steampunk attire, work diligently to fuel the faction's intimidating war machines. He ensures the smooth running of the civilization's intricate, gear-laden infrastructure, his coal-smeared hands working expertly on steam-powered machinery."
$aPrompts[0][1] = "Coalforge Collective - King: Picture The Steam Baron, a commanding woman with short, greying hair, her body covered by her dignified steampunk attire. She stands in the control room of a colossal, cog-filled factory powered by coal. Her firm hands control an intricate network of steampunk devices, efficiently transforming raw coal into potent fuel."
$aPrompts[0][2] = "Coalforge Collective - Queen: Render The Steamweaver, a slender woman with silver hair woven into complex braids, her body modestly covered by her steampunk dress. Her nimble fingers weave steam magic, magically-enhancing coal and channeling it to power the faction's gear-laden machines."
$aPrompts[0][3] = "Coalforge Collective - Jack: Illustrate The Alchemical Artisan, a lean man with copper-colored hair, deeply engrossed in a steampunk-styled alchemical experiment. Around him are vials of potent elixirs and chemical concoctions. His hands manipulate steampunk apparatus, exploring the potential of alchemical reactions to power their industrial might."
$aPrompts[0][4] = "Coalforge Collective - Ten: Portray The Gear Worker, a strong, tireless woman with cropped, sandy hair, her body covered by her work uniform. Amidst the gritty steampunk backdrop of coal mines and giant gears, she adjusts the machinery that fuels the Collective's industrial power."
$aPrompts[0][5] = "Coalforge Collective - Nine: Show The Tinkerer, a spry man with raven-colored hair in a typical steampunk inventor's attire. He's constructing a small, coal-powered automaton, his hands handling intricate gears and levers with dexterity, embodying his innovative spirit."
$aPrompts[0][6] = "Coalforge Collective - Symbol: Design an emblem that encapsulates the essence of the Coalforge Collective. It could include a blackened anvil and a stylized flame encased in a gear, signifying the hardy workers and the coal they skillfully harness. The symbol should emanate the fiery determination and the industrial might of this steampunk faction."

; Automatons
$aPrompts[1][0] = "Automatons - Ace: In a steampunk world, envision the Supreme Engineer Automaton, a powerful humanoid robot with intricate gears and cogs visible under its steel exterior. Standing at human height, this imposing automaton is the ultimate overseer of the faction's steampunk machinery. Its mechanical hands are fitted with various tools for maintenance and adjustments, showcasing its role as the guardian of technological advancements. The Supreme Engineer Automaton exudes authority and intelligence, with glowing, aetheric eyes that reflect its awareness of every cog and gear in its domain. In the background, a sprawling steampunk cityscape demonstrates the influence of this robot in shaping the destiny of the Automatons."
$aPrompts[1][1] = "Automatons - King: In a steampunk world, illustrate the Steam Baron Automaton, a towering figure in the assembly line of automatons. Designed with a sleek, bronze exterior and highly sophisticated internal machinery, it symbolizes the industrial influence and strategic economic power within the automaton faction. This regal automaton stands amidst a bustling factory floor, surrounded by other automatons and human workers. Its presence exudes authority and leadership, with gears turning and steam hissing as it orchestrates the efficient production of steampunk machinery. The Steam Baron Automaton's glowing blue eyes reflect its intelligent decision-making, ensuring the seamless distribution of resources to maintain the faction's dominance."
$aPrompts[1][2] = "Automatons - Queen: In a steampunk world, create an image of the Steamweaver Automaton, a slender, elegant humanoid robot intricately designed with steampunk aesthetics. Steam escapes from its joints and gears as it gracefully manipulates the environment using steam-powered magic, signifying its distinct ability to harness the power of steam in unexpected ways. The Steamweaver Automaton stands amidst a magical laboratory, surrounded by enchanting blueprints and floating vials of mystical potions. Its magical gestures evoke an aura of mystique and wonder, as it imbues a steampunk airship with ethereal energies. This automaton exemplifies the fusion of technology and magic within the Automatons faction."
$aPrompts[1][3] = "Automatons - Jack: In a steampunk world, craft an image of the Alchemical Artisan Automaton, a compact, agile humanoid robot designed with copper accents and a variety of vials and containers integrated into its body. It is shown preparing alchemical potions, its mechanized hands expertly handling the concoctions, showcasing its specialized function in the automaton faction. The Alchemical Artisan Automaton stands in a sophisticated alchemy laboratory, surrounded by bubbling vats and shelves filled with vials of alchemical reagents. Its glowing aetheric eyes convey an air of focus and determination as it creates powerful elixirs and explosive concoctions for the Automatons' endeavors."
$aPrompts[1][4] = "Automatons - Ten: In a steampunk world, create an image of the Gear Worker Automaton, a robust, sturdy humanoid robot with a design emphasizing utility and durability. With its mechanical hands adjusting gears and components on a fellow automaton, it exemplifies the tireless labor that keeps the faction's machinery in prime condition. The Gear Worker Automaton is showcased in a vast, mechanized workshop, filled with towering stacks of gears and mechanical parts. Its expression is diligent and focused, as it ensures the seamless functioning of fellow automatons. The workshop's background illustrates the essential role this automaton plays in maintaining the faction's industrial might."
$aPrompts[1][5] = "Automatons - Nine: In a steampunk world, capture the image of the Tinkerer Automaton, a smaller, more whimsical humanoid robot model surrounded by various intricate gadgets and prototypes. Its intricate design features a number of extra arms and tools, highlighting the inventive nature of its role within the automaton faction. The Tinkerer Automaton stands in a charming steampunk workshop, filled with eccentric gadgets and fantastical contraptions. Its aetheric eyes sparkle with curiosity and mischief as it works on a new invention, demonstrating the unconventional solutions it brings to technological challenges. The workshop's walls are adorned with blueprints and sketches, showcasing the creative spirit of this automaton."
$aPrompts[1][6] = "Automatons - Symbol: In a steampunk world, design a crest that embodies the strength and ingenuity of the Automatons faction. A powerful, humanoid automaton standing within a cog could represent the faction's technological prowess and autonomous strength in the steampunk world. The crest is surrounded by steampunk gears and adorned with intricate aetheric patterns, symbolizing the unity of technology and aetheric energy within the faction. The cog signifies the interconnectedness of the Automatons, each gear contributing to the greater whole of their steampunk society. This powerful crest serves as a symbol of pride and identity for the Automatons in the world of gears and steam."

; Anarchists
$aPrompts[2][0] = "Anarchists - Ace: In a steampunk world, envision the Supreme Engineer of the Anarchists, a striking man with fiery red hair, hidden behind goggles and a leather cap. His intense gaze exudes a sense of rebellious determination, and he stands amidst a chaotic workshop filled with revolutionary contraptions and blueprints. In his hands, he holds blueprints of a massive, steam-powered machine, symbolizing his role as the overseer of all technological advancements within this rebellious faction. The workshop's walls are adorned with posters of defiance, reflecting the Anarchists' commitment to challenging the established order. A banner bearing the emblem of the faction, a clenched fist over a gear, hangs proudly in the background, emphasizing their rebellious spirit."
$aPrompts[2][1] = "Anarchists - King: In a steampunk world, create a compelling image of the Steam Baron, a charismatic man with jet-black hair, dressed in a finely tailored suit with brass accents. He stands confidently in his secret lair, among the factories and workshops of the underground, signifying his significant economic power and control over the production of this faction. The Steam Baron's intense gaze and confident stance exude authority and charisma. Surrounding him are loyal followers, each adorned with symbols of rebellion, reflecting the faction's commitment to challenging the established order. The lair's walls are covered with revolutionary slogans, steam-powered machinery, and gears, showcasing the Anarchists' chaotic yet purposeful existence."
$aPrompts[2][2] = "Anarchists - Queen: In a steampunk world, illustrate the Steamweaver, a mysterious woman with long, silver hair and her body covered by a high-collared, embellished blouse. She stands amidst a swirling mist of steam, her hands making intricate patterns as she channels her power, signifying her essential role within the faction. The Steamweaver's enchanting gaze and graceful gestures exude an air of mystery and defiance. Behind her, a massive steam-powered machinery hums with magical energy, showcasing the Steamweaver's control over steam-based magic. The room is adorned with revolutionary symbols and artifacts, reflecting the faction's rebellious and chaotic nature."
$aPrompts[2][3] = "Anarchists - Jack: In a steampunk world, portray the Alchemical Artisan, a young man with blonde hair and an apron laden with tools. He stands in a cluttered lab, surrounded by test tubes and flasks, showcasing his expertise in alchemy and potion-making. The Alchemical Artisan's mischievous smile and determined expression exude the spirit of rebellion and creative chaos. The lab is filled with experimental potions and volatile concoctions, symbolizing the Anarchists' unpredictable and defiant nature. A banner bearing the faction's emblem, a stylized fist grasping a gear, hangs on the wall, signifying the Alchemical Artisan's allegiance to the cause."
$aPrompts[2][4] = "Anarchists - Ten: In a steampunk world, design the Gear Worker, a sturdy woman with short, brown hair, her clothes covered in grease. She meticulously adjusts a gear on a massive engine, embodying the relentless labor that keeps the machinery of the Anarchist faction running. The Gear Worker's determined expression and sweat-soaked forehead demonstrate her unwavering commitment to the cause. The workshop around her is filled with bustling activity, as other Gear Workers work alongside her, all united in their quest for freedom and rebellion. Revolutionary banners and graffiti adorn the walls, showcasing the faction's spirit of defiance."
$aPrompts[2][5] = "Anarchists - Nine: In a steampunk world, capture the essence of the Tinkerer, an elderly man with white hair, seen through his goggles, busy with a new invention. The eccentric inventor is surrounded by a chaos of gears, springs, and steam, a testament to his creative genius. The Tinkerer's eyes gleam with excitement and rebellious spirit as he tinkers with a revolutionary device. The workshop is a sanctuary of creativity and innovation, filled with discarded blueprints, half-built machines, and revolutionary trinkets. A banner bearing the faction's emblem, a clenched fist grasping a gear wreathed in steam, hangs prominently, reflecting the Tinkerer's dedication to the Anarchists' cause."
$aPrompts[2][6] = "Anarchists - Symbol: In a steampunk world, craft a crest that embodies the rebellious spirit of the Anarchists faction. A stylized fist, grasping a gear and wreathed in steam, could symbolize their defiance and ingenuity within the steampunk world. The fist represents the Anarchists' unwavering determination to challenge authority and the gear symbolizes their technological prowess. The steam surrounding the emblem signifies the chaotic and unpredictable nature of their rebellion. The crest is adorned with revolutionary symbols and surrounded by gears and cogwheels, showcasing the faction's commitment to disrupting the established order."


; Sky Wardens
$aPrompts[3][0] = "Sky Wardens - Ace: In a steampunk world, visualize the Supreme Engineer of the Sky Wardens, a stern man with wind-tousled dark hair. Adorned in an intricate uniform laden with gears and adorned with wings, he stands before a massive airship engine, his authority over the technological advancements of the faction evident."
$aPrompts[3][1] = "Sky Wardens - King: In a steampunk world, render the Steam Baron of the Sky Wardens, a distinguished man with gleaming, silver hair. He oversees the industrious scene of airship production from a high vantage point, his powerful stature implying his economic might and influence over the airship industry."
$aPrompts[3][2] = "Sky Wardens - Queen: In a steampunk world, depict the Steamweaver, a noble woman with long, flowing blonde hair, her body modestly covered by a high-collared, elegantly detailed uniform. She displays her command over steam-powered magic, her fingertips glowing with energy, signifying her vital role within the Sky Wardens."
$aPrompts[3][3] = "Sky Wardens - Jack: In a steampunk world, picture the Alchemical Artisan, a young man with fiery red hair, amidst the hustle and bustle of an airship's medic bay. His hands expertly handle various vials and concoctions, indicative of his knowledge in alchemy and its use in the faction's healthcare and warfare."
$aPrompts[3][4] = "Sky Wardens - Ten: In a steampunk world, illustrate the Gear Worker, a robust woman with short, chestnut hair, in the heart of a colossal airship. Engrossed in maintaining the machine's gears, she embodies the tireless labor that ensures the smooth operation of the Sky Wardens' fleets."
$aPrompts[3][5] = "Sky Wardens - Nine: In a steampunk world, capture the Tinkerer, an older man with grizzled white hair, engrossed in the invention of a new aeronautical device. His workspace is filled with blueprints, gears, and steam, underlining his inventive spirit within the faction."
$aPrompts[3][6] = "Sky Wardens - Symbol: In a steampunk world, craft the crest for the Sky Wardens. A stylized winged shield or a steampunk helmet against the backdrop of clouds could symbolize their role as the guardians of the skies in this steampunk world."

; Clockwork Syndicate
$aPrompts[4][0] = "Clockwork Syndicate - Ace: In a steampunk world, visualize the Supreme Engineer of the Clockwork Syndicate, a man with slick, black hair, his eyes gleaming behind intricate goggles. He wields a blueprint of an intricate clockwork device, signifying his superior understanding of time manipulation technology."
$aPrompts[4][1] = "Clockwork Syndicate - King: In a steampunk world, illustrate the Steam Baron, a man with salt-and-pepper hair, cloaked in an elegantly tailored suit. In a dimly lit room filled with ticking clocks, he oversees the clandestine operations of the faction, indicating his economic influence and control."
$aPrompts[4][2] = "Clockwork Syndicate - Queen: In a steampunk world, depict the Steamweaver, a woman with vibrant red hair, her body tastefully covered by a high-necked, intricate dress. Her hands move in mesmerizing patterns as she infuses a clockwork device with magical steam, displaying her key role in the faction."
$aPrompts[4][3] = "Clockwork Syndicate - Jack: In a steampunk world, envision the Alchemical Artisan, a man with curly brown hair, surrounded by a myriad of flasks and hourglasses. His hands work with a potion that glows with the colors of a twilight sky, showcasing his expertise in alchemy within the faction."
$aPrompts[4][4] = "Clockwork Syndicate - Ten: In a steampunk world, create an image of the Gear Worker, a woman with a pixie cut and deep brown hair, engrossed in the maintenance of a complex clockwork mechanism. She represents the unyielding work that keeps the faction's time-bending machinery operational."
$aPrompts[4][5] = "Clockwork Syndicate - Nine: In a steampunk world, capture the Tinkerer, a man with long, white hair tied back, amidst a chaos of gears, springs, and timepieces. His innovative spirit is palpable as he dedicates himself to a new time-manipulating invention."
$aPrompts[4][6] = "Clockwork Syndicate - Symbol: In a steampunk world, design the crest for the Clockwork Syndicate. An elaborate timepiece, with gears and springs intertwined, set against a starry sky, could symbolize their mastery of time within this steampunk world."

ConsoleWrite(_ArrayToString($aPrompts, ", ", Default, Default, @CRLF))
; Displaying the prompts
;~ _ArrayDisplay($aPrompts, "Steampunk Prompts")


For $Row = 0 To UBound($aPrompts) - 1
	For $Col = 0 To UBound($aPrompts, 2) - 1
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		If Not StringInStr($aPrompts[$Row][$Col], 'Anarchists') Or StringInStr($aPrompts[$Row][$Col], 'Anarchists - Ace') Then
			ContinueLoop
		EndIf
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		WinActivate('Text to Image | Imagine AI Art Generator - Google Chrome')
		If $Col = UBound($aPrompts, 2) - 1 Then
			MouseClick('left', 1716, 198, 1, 0)
		Else
			MouseClick('left', 1761, 199, 1, 0)
		EndIf
		Sleep(250)

		MouseClick('left', 712, 932, 1, 0)
		Send('^{a}')
		$sSendText = StringTrimLeft($aPrompts[$Row][$Col], StringInStr($aPrompts[$Row][$Col], ':') + 1)
		$sFolder = StringReplace(StringLeft($aPrompts[$Row][$Col], StringInStr($aPrompts[$Row][$Col], ':') - 1), '=', '-')
		Sleep(100)
		Send($sSendText)

		For $y = 1 To 10 ;number of images
			MouseClick('left', 1322, 940, 1, 0)
			Sleep(3000)
			While PixelGetColor(1301, 928) <> 16777215
				ConsoleWrite(PixelGetColor(1301, 928) & @CRLF)
				Sleep(1000)
			WEnd
			Sleep(500)
		Next

		MouseClick('left', 1810, 106, 1, 0)
		Sleep(5000)
		$aFiles = _FileListToArray(@UserProfileDir & '\Downloads', '*', 1) ;1=Files
		For $y = 1 To UBound($aFiles) - 1
			FileMove(@UserProfileDir & '\Downloads\' & $aFiles[$y], @UserProfileDir & '\Downloads\' & $sFolder & '\' & $aFiles[$y], 9)
		Next
	Next
Next

Func _Exit()
	Exit
EndFunc   ;==>_Exit
