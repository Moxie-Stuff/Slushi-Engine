package states;

import objects.AttachedSprite;

class CreditsState extends MusicBeatState
{
  var curSelected:Int = -1;

  private var grpOptions:FlxTypedGroup<Alphabet>;
  private var iconArray:Array<AttachedSprite> = [];
  private var creditsStuff:Array<Array<String>> = [];

  var bg:FlxSprite;
  var descText:FlxText;
  var intendedColor:FlxColor;
  var colorTween:FlxTween;
  var descBox:AttachedSprite;

  var offsetThing:Float = -75;

  override function create()
  {
    #if DISCORD_ALLOWED
    // Updating Discord Rich Presence
    DiscordClient.changePresence("In the Menus", null);
    #end

    persistentUpdate = true;
    bg = new FlxSprite().loadGraphic(Paths.image('stageBackForStates'));
    bg.antialiasing = ClientPrefs.data.antialiasing;
    add(bg);
    bg.screenCenter();

    grpOptions = new FlxTypedGroup<Alphabet>();
    add(grpOptions);

    #if MODS_ALLOWED
    for (mod in Mods.parseList().enabled)
      pushModCreditsToList(mod);
    #end

    var defaultList:Array<Array<String>> = [
      // Name - Icon name - Description - Link - BG Color
      ['Sick Coders Engine\'s Team'],
      [
        'Edwhak_Killbot',
        'edwhak',
        'Main Leader of SCE',
        'https://github.com/EdwhakKB',
        '005B16'
      ],
      [
        'Glowsoony',
        '',
        'Leader in coding of SCE',
        'https://github.com/glowsoony',
        '89C8FF'
      ],
      [
        'Slushi',
        'slushi',
        'Beta-Tester and MADE CRASH HANDLER',
        'https://github.com/Slushi-Github',
        '8FD9D1'
      ],
      [''],
      ["Psych Engine Team"],
      [
        "Shadow Mario",
        "shadowmario",
        "Main Programmer and Head of Psych Engine",
        "https://ko-fi.com/shadowmario",
        "444444"
      ],
      [
        "Riveren",
        "riveren",
        "Main Artist/Animator of Psych Engine",
        "https://twitter.com/riverennn",
        "14967B"
      ],
      [""],
      ["Former Engine Members"],
      [
        "bb-panzu",
        "bb",
        "Ex-Programmer of Psych Engine",
        "https://twitter.com/bbsub3",
        "3E813A"
      ],
      [""],
      ["Engine Contributors"],
      [
        "CrowPlexus",
        "crowplexus",
        "Hscript Iris, Input System v3, and Other PRs",
        "https://twitter.com/crowplexus",
        "CFCFCF"
      ],
      [
        "Kamizeta",
        "kamizeta",
        "Creator of Pessy, Psych Engine's mascot.",
        "https://twitter.com/LittleCewwy",
        "D21C11"
      ],
      [
        "MaxNeton",
        "maxneton",
        "Loading Screen Easter Egg Artist/Animator.",
        "https://twitter.com/MaxNeton",
        "3C2E4E"
      ],
      [
        "Keoiki",
        "keoiki",
        "Note Splash Animations and Latin Alphabet",
        "https://twitter.com/Keoiki_",
        "D2D2D2"
      ],
      [
        "SqirraRNG",
        "sqirra",
        "Crash Handler and Base code for\nChart Editor's Waveform",
        "https://twitter.com/gedehari",
        "E1843A"
      ],
      [
        "EliteMasterEric",
        "mastereric",
        "Runtime Shaders support and Other PRs",
        "https://twitter.com/EliteMasterEric",
        "FFBD40"
      ],
      [
        "MAJigsaw77",
        "majigsaw",
        ".MP4 Video Loader Library (hxvlc)",
        "https://twitter.com/MAJigsaw77",
        "5F5F5F"
      ],
      [
        "Tahir Toprak Karabekiroglu",
        "tahir",
        "Note Splash Editor and Other PRs",
        "https://twitter.com/TahirKarabekir",
        "A04397"
      ],
      [
        "iFlicky",
        "flicky",
        "Composer of Psync and Tea Time\nMade the Dialogue Sounds",
        "https://twitter.com/flicky_i",
        "9E29CF"
      ],
      [
        "KadeDev",
        "kade",
        "Fixed some issues on Chart Editor and Other PRs",
        "https://twitter.com/kade0912",
        "64A250"
      ],
      [
        "superpowers04",
        "superpowers04",
        "LUA JIT Fork",
        "https://twitter.com/superpowers04",
        "B957ED"
      ],
      [
        "CheemsAndFriends",
        "cheems",
        "Creator of FlxAnimate",
        "https://twitter.com/CheemsnFriendos",
        "E1E1E1"
      ],
      [""],
      ["Funkin' Crew"],
      [
        "ninjamuffin99",
        "ninjamuffin99",
        "Programmer of Friday Night Funkin'",
        "https://twitter.com/ninja_muffin99",
        "CF2D2D"
      ],
      [
        "PhantomArcade",
        "phantomarcade",
        "Animator of Friday Night Funkin'",
        "https://twitter.com/PhantomArcade3K",
        "FADC45"
      ],
      [
        "evilsk8r",
        "evilsk8r",
        "Artist of Friday Night Funkin'",
        "https://twitter.com/evilsk8r",
        "5ABD4B"
      ],
      [
        "kawaisprite",
        "kawaisprite",
        "Composer of Friday Night Funkin'",
        "https://twitter.com/kawaisprite",
        "378FC7"
      ],
      [''],
      ['Code From Others'],
      [
        'Blantados',
        'blantados',
        "Progammer of BETADCIU and code used from this engine to SCE!",
        'https://github.com/Blantados',
        '64B3FE'
      ],
      [
        'Bolo Vevo',
        '',
        "Most code for things gotten from this man's kade!",
        'https://github.com/BoloVEVO',
        'C7B1AB'
      ],
      [
        'Haone',
        '',
        "Extra Function code for Chart editor.",
        'https://github.com/haoneRG',
        '879AD9'
      ],
      [""],
      ["Psych Engine Discord"],
      ["Join the Psych Ward!", "discord", "", "https://discord.gg/2ka77eMXDv", "5165F6"]
    ];

    for (i in defaultList)
      creditsStuff.push(i);

    for (i => credit in creditsStuff)
    {
      var isSelectable:Bool = !unselectableCheck(i);
      var optionText:Alphabet = new Alphabet(FlxG.width / 2, 300, credit[0], !isSelectable);
      optionText.isMenuItem = true;
      optionText.targetY = i;
      optionText.changeX = false;
      optionText.snapToPosition();
      grpOptions.add(optionText);

      if (isSelectable)
      {
        if (credit[5] != null) Mods.currentModDirectory = credit[5];

        var str:String = 'credits/missing_icon';
        if (credit[1] != null && credit[1].length > 0)
        {
          var fileName = 'credits/' + credit[1];
          if (Paths.fileExists('images/$fileName.png', IMAGE)) str = fileName;
          else if (Paths.fileExists('images/$fileName-pixel.png', IMAGE)) str = fileName + '-pixel';
        }

        var icon:AttachedSprite = new AttachedSprite(str);
        if (str.contains('pixel')) icon.antialiasing = false;
        icon.xAdd = optionText.width + 10;
        icon.sprTracker = optionText;

        // using a FlxGroup is too much fuss!
        iconArray.push(icon);
        add(icon);
        Mods.currentModDirectory = '';

        if (curSelected == -1) curSelected = i;
      }
      else
        optionText.alignment = CENTERED;
    }

    descBox = new AttachedSprite();
    descBox.makeGraphic(1, 1, FlxColor.BLACK);
    descBox.xAdd = -10;
    descBox.yAdd = -10;
    descBox.alphaMult = 0.6;
    descBox.alpha = 0.6;
    add(descBox);

    descText = new FlxText(50, FlxG.height + offsetThing - 25, 1180, "", 32);
    descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER /*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
    descText.scrollFactor.set();
    // descText.borderSize = 2.4;
    descBox.sprTracker = descText;
    add(descText);

    bg.color = CoolUtil.colorFromString(creditsStuff[curSelected][4]);
    intendedColor = bg.color;
    changeSelection();
    super.create();
  }

  var quitting:Bool = false;
  var holdTime:Float = 0;

  override function update(elapsed:Float)
  {
    if (FlxG.sound.music.volume < 0.7)
    {
      FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
    }

    if (!quitting)
    {
      if (creditsStuff.length > 1)
      {
        var shiftMult:Int = 1;
        if (FlxG.keys.pressed.SHIFT) shiftMult = 3;

        var upP = controls.UI_UP_P;
        var downP = controls.UI_DOWN_P;

        if (upP)
        {
          changeSelection(-shiftMult);
          holdTime = 0;
        }
        if (downP)
        {
          changeSelection(shiftMult);
          holdTime = 0;
        }

        if (controls.UI_DOWN || controls.UI_UP)
        {
          var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
          holdTime += elapsed;
          var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

          if (holdTime > 0.5 && checkNewHold - checkLastHold > 0)
          {
            changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
          }
        }
      }

      if (controls.ACCEPT && (creditsStuff[curSelected][3] == null || creditsStuff[curSelected][3].length > 4))
      {
        CoolUtil.browserLoad(creditsStuff[curSelected][3]);
      }
      if (controls.BACK)
      {
        if (colorTween != null)
        {
          colorTween.cancel();
        }
        FlxG.sound.play(Paths.sound('cancelMenu'));
        MusicBeatState.switchState(new slushi.states.SlushiMainMenuState());
        quitting = true;
      }
    }

    for (item in grpOptions.members)
    {
      if (!item.bold)
      {
        var lerpVal:Float = Math.exp(-elapsed * 12);
        if (item.targetY == 0)
        {
          var lastX:Float = item.x;
          item.screenCenter(X);
          item.x = FlxMath.lerp(item.x - 70, lastX, lerpVal);
        }
        else
        {
          item.x = FlxMath.lerp(200 + -40 * Math.abs(item.targetY), item.x, lerpVal);
        }
      }
    }
    super.update(elapsed);
  }

  var moveTween:FlxTween = null;

  function changeSelection(change:Int = 0)
  {
    FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
    do
    {
      curSelected += change;
      if (curSelected < 0) curSelected = creditsStuff.length - 1;
      if (curSelected >= creditsStuff.length) curSelected = 0;
    }
    while (unselectableCheck(curSelected));

    var newColor:FlxColor = CoolUtil.colorFromString(creditsStuff[curSelected][4]);
    if (newColor != intendedColor)
    {
      if (colorTween != null)
      {
        colorTween.cancel();
      }
      intendedColor = newColor;
      colorTween = FlxTween.color(bg, 1, bg.color, intendedColor,
        {
          onComplete: function(twn:FlxTween) {
            colorTween = null;
          }
        });
    }

    var bullShit:Int = 0;

    for (item in grpOptions.members)
    {
      item.targetY = bullShit - curSelected;
      bullShit++;

      if (!unselectableCheck(bullShit - 1))
      {
        item.alpha = 0.6;
        if (item.targetY == 0)
        {
          item.alpha = 1;
        }
      }
    }

    descText.text = creditsStuff[curSelected][2];
    if (descText.text.trim().length > 0)
    {
      descText.visible = descBox.visible = true;
      descText.y = FlxG.height - descText.height + offsetThing - 60;

      if (moveTween != null) moveTween.cancel();
      moveTween = FlxTween.tween(descText, {y: descText.y + 75}, 0.25, {ease: FlxEase.sineOut});

      descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
      descBox.updateHitbox();
    }
    else
      descText.visible = descBox.visible = false;
  }

  #if MODS_ALLOWED
  function pushModCreditsToList(folder:String)
  {
    var creditsFile:String = Paths.mods(folder + '/data/credits.txt');

    #if TRANSLATIONS_ALLOWED
    // trace('/data/credits-${ClientPrefs.data.language}.txt');
    var translatedCredits:String = Paths.mods(folder + '/data/credits-${ClientPrefs.data.language}.txt');
    #end

    if (#if TRANSLATIONS_ALLOWED (FileSystem.exists(translatedCredits) && (creditsFile = translatedCredits) == translatedCredits)
      || #end FileSystem.exists(creditsFile))
    {
      var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
      for (i in firstarray)
      {
        var arr:Array<String> = i.replace('\\n', '\n').split("::");
        if (arr.length >= 5) arr.push(folder);
        creditsStuff.push(arr);
      }
      creditsStuff.push(['']);
    }
  }
  #end

  private function unselectableCheck(num:Int):Bool
  {
    return creditsStuff[num].length <= 1;
  }
}