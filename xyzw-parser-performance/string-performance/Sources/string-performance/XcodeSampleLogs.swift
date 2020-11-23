let xcodeLogs = #"""
2020-11-15T22:46:57.8892230Z ##[section]Starting: Request a runner to run this job
2020-11-15T22:46:58.4371787Z Can't find any online and idle self-hosted runner in current repository that matches the required labels: 'macOS-latest'
2020-11-15T22:46:58.4371897Z Can't find any online and idle self-hosted runner in current repository's account/organization that matches the required labels: 'macOS-latest'
2020-11-15T22:46:58.4590432Z Found online and idle hosted runner in current repository's account/organization that matches the required labels: 'macOS-latest'
2020-11-15T22:46:58.5535983Z ##[section]Finishing: Request a runner to run this job
2020-11-15T22:47:10.2467410Z Current runner version: '2.274.1'
2020-11-15T22:47:10.2562610Z ##[group]Operating System
2020-11-15T22:47:10.2563470Z Mac OS X
2020-11-15T22:47:10.2563780Z 10.15.7
2020-11-15T22:47:10.2564140Z 19H15
2020-11-15T22:47:10.2564450Z ##[endgroup]
2020-11-15T22:47:10.2564770Z ##[group]Virtual Environment
2020-11-15T22:47:10.2565210Z Environment: macos-10.15
2020-11-15T22:47:10.2565570Z Version: 20201107.1
2020-11-15T22:47:10.2566290Z Included Software: https://github.com/actions/virtual-environments/blob/macos-10.15/20201107.1/images/macos/macos-10.15-Readme.md
2020-11-15T22:47:10.2567020Z ##[endgroup]
2020-11-15T22:47:10.2570610Z Prepare workflow directory
2020-11-15T22:47:10.3324730Z Prepare all required actions
2020-11-15T22:47:10.3336840Z Getting action download info
2020-11-15T22:47:10.6532190Z Download action repository 'actions/checkout@v2'
2020-11-15T22:47:11.6939740Z ##[group]Run actions/checkout@v2
2020-11-15T22:47:11.6940360Z with:
2020-11-15T22:47:11.6940970Z   repository: pointfreeco/pointfreeco
2020-11-15T22:47:11.6941660Z   token: ***
2020-11-15T22:47:11.6942000Z   ssh-strict: true
2020-11-15T22:47:11.6942390Z   persist-credentials: true
2020-11-15T22:47:11.6942760Z   clean: true
2020-11-15T22:47:11.6943020Z   fetch-depth: 1
2020-11-15T22:47:11.6943460Z   lfs: false
2020-11-15T22:47:11.6943790Z   submodules: false
2020-11-15T22:47:11.6944110Z ##[endgroup]
2020-11-15T22:47:12.8756040Z Syncing repository: pointfreeco/pointfreeco
2020-11-15T22:47:12.8757130Z ##[group]Getting Git version info
2020-11-15T22:47:12.8759110Z Working directory is '/Users/runner/work/pointfreeco/pointfreeco'
2020-11-15T22:47:12.8760110Z [command]/usr/local/bin/git version
2020-11-15T22:47:12.8760600Z git version 2.29.2
2020-11-15T22:47:12.8762150Z ##[endgroup]
2020-11-15T22:47:12.8763110Z Deleting the contents of '/Users/runner/work/pointfreeco/pointfreeco'
2020-11-15T22:47:12.8765710Z ##[group]Initializing the repository
2020-11-15T22:47:12.8766590Z [command]/usr/local/bin/git init /Users/runner/work/pointfreeco/pointfreeco
2020-11-15T22:47:12.8767630Z Initialized empty Git repository in /Users/runner/work/pointfreeco/pointfreeco/.git/
2020-11-15T22:47:12.8768740Z [command]/usr/local/bin/git remote add origin https://github.com/pointfreeco/pointfreeco
2020-11-15T22:47:12.8769620Z ##[endgroup]
2020-11-15T22:47:12.8770330Z ##[group]Disabling automatic garbage collection
2020-11-15T22:47:12.8771490Z [command]/usr/local/bin/git config --local gc.auto 0
2020-11-15T22:47:12.8772220Z ##[endgroup]
2020-11-15T22:47:12.8819080Z ##[group]Setting up auth
2020-11-15T22:47:12.8820380Z [command]/usr/local/bin/git config --local --name-only --get-regexp core\.sshCommand
2020-11-15T22:47:12.8822030Z [command]/usr/local/bin/git submodule foreach --recursive git config --local --name-only --get-regexp 'core\.sshCommand' && git config --local --unset-all 'core.sshCommand' || :
2020-11-15T22:47:12.8823720Z [command]/usr/local/bin/git config --local --name-only --get-regexp http\.https\:\/\/github\.com\/\.extraheader
2020-11-15T22:47:12.8825670Z [command]/usr/local/bin/git submodule foreach --recursive git config --local --name-only --get-regexp 'http\.https\:\/\/github\.com\/\.extraheader' && git config --local --unset-all 'http.https://github.com/.extraheader' || :
2020-11-15T22:47:12.8827620Z [command]/usr/local/bin/git config --local http.https://github.com/.extraheader AUTHORIZATION: basic ***
2020-11-15T22:47:12.8828580Z ##[endgroup]
2020-11-15T22:47:12.8829220Z ##[group]Fetching the repository
2020-11-15T22:47:12.8830870Z [command]/usr/local/bin/git -c protocol.version=2 fetch --no-tags --prune --progress --no-recurse-submodules --depth=1 origin +fab6d0cc57614314d79e4bd2307f4273a474b5b5:refs/remotes/origin/main
2020-11-15T22:47:13.0924270Z remote: Enumerating objects: 1032, done.
2020-11-15T22:47:13.0925130Z remote: Counting objects:   0% (1/1032)
2020-11-15T22:47:13.0925790Z remote: Counting objects:   1% (11/1032)
2020-11-15T22:47:13.0964550Z remote: Counting objects:   2% (21/1032)
2020-11-15T22:47:13.0966120Z remote: Counting objects:   3% (31/1032)
2020-11-15T22:47:13.0967800Z remote: Counting objects:   4% (42/1032)
2020-11-15T22:47:13.0968390Z remote: Counting objects:   5% (52/1032)
2020-11-15T22:47:13.0969120Z remote: Counting objects:   6% (62/1032)
2020-11-15T22:47:13.0970130Z remote: Counting objects:   7% (73/1032)
2020-11-15T22:47:13.0971030Z remote: Counting objects:   8% (83/1032)
2020-11-15T22:47:13.0971750Z remote: Counting objects:   9% (93/1032)
2020-11-15T22:47:13.0972360Z remote: Counting objects:  10% (104/1032)
2020-11-15T22:47:13.0972980Z remote: Counting objects:  11% (114/1032)
2020-11-15T22:47:13.0973620Z remote: Counting objects:  12% (124/1032)
2020-11-15T22:47:13.0974730Z remote: Counting objects:  13% (135/1032)
2020-11-15T22:47:13.0976240Z remote: Counting objects:  14% (145/1032)
2020-11-15T22:47:13.0976980Z remote: Counting objects:  15% (155/1032)
2020-11-15T22:47:13.0977920Z remote: Counting objects:  16% (166/1032)
2020-11-15T22:47:13.0978680Z remote: Counting objects:  17% (176/1032)
2020-11-15T22:47:13.0979340Z remote: Counting objects:  18% (186/1032)
2020-11-15T22:47:13.0980100Z remote: Counting objects:  19% (197/1032)
2020-11-15T22:47:13.0980490Z remote: Counting objects:  20% (207/1032)
2020-11-15T22:47:13.0980910Z remote: Counting objects:  21% (217/1032)
2020-11-15T22:47:13.0981310Z remote: Counting objects:  22% (228/1032)
2020-11-15T22:47:13.0981700Z remote: Counting objects:  23% (238/1032)
2020-11-15T22:47:13.0982100Z remote: Counting objects:  24% (248/1032)
2020-11-15T22:47:13.0982500Z remote: Counting objects:  25% (258/1032)
2020-11-15T22:47:13.0982860Z remote: Counting objects:  26% (269/1032)
2020-11-15T22:47:13.0983290Z remote: Counting objects:  27% (279/1032)
2020-11-15T22:47:13.0983700Z remote: Counting objects:  28% (289/1032)
2020-11-15T22:47:13.0984110Z remote: Counting objects:  29% (300/1032)
2020-11-15T22:47:13.0984530Z remote: Counting objects:  30% (310/1032)
2020-11-15T22:47:13.0984930Z remote: Counting objects:  31% (320/1032)
2020-11-15T22:47:13.0986030Z remote: Counting objects:  32% (331/1032)
2020-11-15T22:47:13.0986440Z remote: Counting objects:  33% (341/1032)
2020-11-15T22:47:13.0986820Z remote: Counting objects:  34% (351/1032)
2020-11-15T22:47:13.0987220Z remote: Counting objects:  35% (362/1032)
2020-11-15T22:47:13.0987580Z remote: Counting objects:  36% (372/1032)
2020-11-15T22:47:13.0987990Z remote: Counting objects:  37% (382/1032)
2020-11-15T22:47:13.0988400Z remote: Counting objects:  38% (393/1032)
2020-11-15T22:47:13.0989220Z remote: Counting objects:  39% (403/1032)
2020-11-15T22:47:13.0989680Z remote: Counting objects:  40% (413/1032)
2020-11-15T22:47:13.0990330Z remote: Counting objects:  41% (424/1032)
2020-11-15T22:47:13.0990930Z remote: Counting objects:  42% (434/1032)
2020-11-15T22:47:13.0991560Z remote: Counting objects:  43% (444/1032)
2020-11-15T22:47:13.0992160Z remote: Counting objects:  44% (455/1032)
2020-11-15T22:47:13.0992800Z remote: Counting objects:  45% (465/1032)
2020-11-15T22:47:13.0993410Z remote: Counting objects:  46% (475/1032)
2020-11-15T22:47:13.0994040Z remote: Counting objects:  47% (486/1032)
2020-11-15T22:47:13.0994650Z remote: Counting objects:  48% (496/1032)
2020-11-15T22:47:13.0995240Z remote: Counting objects:  49% (506/1032)
2020-11-15T22:47:13.0995850Z remote: Counting objects:  50% (516/1032)
2020-11-15T22:47:13.0996450Z remote: Counting objects:  51% (527/1032)
2020-11-15T22:47:13.0997090Z remote: Counting objects:  52% (537/1032)
2020-11-15T22:47:13.0997830Z remote: Counting objects:  53% (547/1032)
2020-11-15T22:47:13.0998500Z remote: Counting objects:  54% (558/1032)
2020-11-15T22:47:13.0999150Z remote: Counting objects:  55% (568/1032)
2020-11-15T22:47:13.1000180Z remote: Counting objects:  56% (578/1032)
2020-11-15T22:47:13.1000840Z remote: Counting objects:  57% (589/1032)
2020-11-15T22:47:13.1001450Z remote: Counting objects:  58% (599/1032)
2020-11-15T22:47:13.1002090Z remote: Counting objects:  59% (609/1032)
2020-11-15T22:47:13.1002680Z remote: Counting objects:  60% (620/1032)
2020-11-15T22:47:13.1003100Z remote: Counting objects:  61% (630/1032)
2020-11-15T22:47:13.1003490Z remote: Counting objects:  62% (640/1032)
2020-11-15T22:47:13.1003860Z remote: Counting objects:  63% (651/1032)
2020-11-15T22:47:13.1004260Z remote: Counting objects:  64% (661/1032)
2020-11-15T22:47:13.1004660Z remote: Counting objects:  65% (671/1032)
2020-11-15T22:47:13.1005330Z remote: Counting objects:  66% (682/1032)
2020-11-15T22:47:13.1005770Z remote: Counting objects:  67% (692/1032)
2020-11-15T22:47:13.1006490Z remote: Counting objects:  68% (702/1032)
2020-11-15T22:47:13.1007160Z remote: Counting objects:  69% (713/1032)
2020-11-15T22:47:13.1007850Z remote: Counting objects:  70% (723/1032)
2020-11-15T22:47:13.1008590Z remote: Counting objects:  71% (733/1032)
2020-11-15T22:47:13.1009210Z remote: Counting objects:  72% (744/1032)
2020-11-15T22:47:13.1009830Z remote: Counting objects:  73% (754/1032)
2020-11-15T22:47:13.1010470Z remote: Counting objects:  74% (764/1032)
2020-11-15T22:47:13.1011090Z remote: Counting objects:  75% (774/1032)
2020-11-15T22:47:13.1011810Z remote: Counting objects:  76% (785/1032)
2020-11-15T22:47:13.1012360Z remote: Counting objects:  77% (795/1032)
2020-11-15T22:47:13.1013250Z remote: Counting objects:  78% (805/1032)
2020-11-15T22:47:13.1014070Z remote: Counting objects:  79% (816/1032)
2020-11-15T22:47:13.1014540Z remote: Counting objects:  80% (826/1032)
2020-11-15T22:47:13.1014960Z remote: Counting objects:  81% (836/1032)
2020-11-15T22:47:13.1015330Z remote: Counting objects:  82% (847/1032)
2020-11-15T22:47:13.1015700Z remote: Counting objects:  83% (857/1032)
2020-11-15T22:47:13.1016080Z remote: Counting objects:  84% (867/1032)
2020-11-15T22:47:13.1016430Z remote: Counting objects:  85% (878/1032)
2020-11-15T22:47:13.1016810Z remote: Counting objects:  86% (888/1032)
2020-11-15T22:47:13.1017180Z remote: Counting objects:  87% (898/1032)
2020-11-15T22:47:13.1017550Z remote: Counting objects:  88% (909/1032)
2020-11-15T22:47:13.1017930Z remote: Counting objects:  89% (919/1032)
2020-11-15T22:47:13.1018300Z remote: Counting objects:  90% (929/1032)
2020-11-15T22:47:13.1018680Z remote: Counting objects:  91% (940/1032)
2020-11-15T22:47:13.1019490Z remote: Counting objects:  92% (950/1032)
2020-11-15T22:47:13.1020180Z remote: Counting objects:  93% (960/1032)
2020-11-15T22:47:13.1020830Z remote: Counting objects:  94% (971/1032)
2020-11-15T22:47:13.1021420Z remote: Counting objects:  95% (981/1032)
2020-11-15T22:47:13.1023790Z remote: Counting objects:  96% (991/1032)
2020-11-15T22:47:13.1025070Z remote: Counting objects:  97% (1002/1032)
2020-11-15T22:47:13.1025650Z remote: Counting objects:  98% (1012/1032)
2020-11-15T22:47:13.1026050Z remote: Counting objects:  99% (1022/1032)
2020-11-15T22:47:13.1026430Z remote: Counting objects: 100% (1032/1032)
2020-11-15T22:47:13.1026820Z remote: Counting objects: 100% (1032/1032), done.
2020-11-15T22:47:13.1027270Z remote: Compressing objects:   0% (1/903)
2020-11-15T22:47:13.1027710Z remote: Compressing objects:   1% (10/903)
2020-11-15T22:47:13.1028130Z remote: Compressing objects:   2% (19/903)
2020-11-15T22:47:13.1123950Z remote: Compressing objects:   3% (28/903)
2020-11-15T22:47:13.1302710Z remote: Compressing objects:   4% (37/903)
2020-11-15T22:47:13.1448100Z remote: Compressing objects:   5% (46/903)
2020-11-15T22:47:13.1508560Z remote: Compressing objects:   6% (55/903)
2020-11-15T22:47:13.1558430Z remote: Compressing objects:   7% (64/903)
2020-11-15T22:47:13.1678440Z remote: Compressing objects:   8% (73/903)
2020-11-15T22:47:13.1703420Z remote: Compressing objects:   9% (82/903)
2020-11-15T22:47:13.1704820Z remote: Compressing objects:  10% (91/903)
2020-11-15T22:47:13.1733170Z remote: Compressing objects:  11% (100/903)
2020-11-15T22:47:13.1745890Z remote: Compressing objects:  12% (109/903)
2020-11-15T22:47:13.1899800Z remote: Compressing objects:  13% (118/903)
2020-11-15T22:47:13.1932490Z remote: Compressing objects:  14% (127/903)
2020-11-15T22:47:13.1953350Z remote: Compressing objects:  15% (136/903)
2020-11-15T22:47:13.1953990Z remote: Compressing objects:  16% (145/903)
2020-11-15T22:47:13.1961900Z remote: Compressing objects:  17% (154/903)
2020-11-15T22:47:13.1999210Z remote: Compressing objects:  18% (163/903)
2020-11-15T22:47:13.2020270Z remote: Compressing objects:  19% (172/903)
2020-11-15T22:47:13.2039600Z remote: Compressing objects:  20% (181/903)
2020-11-15T22:47:13.2061260Z remote: Compressing objects:  21% (190/903)
2020-11-15T22:47:13.2061800Z remote: Compressing objects:  22% (199/903)
2020-11-15T22:47:13.2088600Z remote: Compressing objects:  23% (208/903)
2020-11-15T22:47:13.2089170Z remote: Compressing objects:  24% (217/903)
2020-11-15T22:47:13.2104410Z remote: Compressing objects:  25% (226/903)
2020-11-15T22:47:13.2129930Z remote: Compressing objects:  26% (235/903)
2020-11-15T22:47:13.2150720Z remote: Compressing objects:  27% (244/903)
2020-11-15T22:47:13.2171760Z remote: Compressing objects:  28% (253/903)
2020-11-15T22:47:13.2175590Z remote: Compressing objects:  29% (262/903)
2020-11-15T22:47:13.2192120Z remote: Compressing objects:  30% (271/903)
2020-11-15T22:47:13.2214660Z remote: Compressing objects:  31% (280/903)
2020-11-15T22:47:13.2268470Z remote: Compressing objects:  32% (289/903)
2020-11-15T22:47:13.2286290Z remote: Compressing objects:  33% (298/903)
2020-11-15T22:47:13.2332860Z remote: Compressing objects:  34% (308/903)
2020-11-15T22:47:13.2360700Z remote: Compressing objects:  35% (317/903)
2020-11-15T22:47:13.2379090Z remote: Compressing objects:  36% (326/903)
2020-11-15T22:47:13.2410330Z remote: Compressing objects:  37% (335/903)
2020-11-15T22:47:13.2421720Z remote: Compressing objects:  38% (344/903)
2020-11-15T22:47:13.2427930Z remote: Compressing objects:  39% (353/903)
2020-11-15T22:47:13.2453820Z remote: Compressing objects:  40% (362/903)
2020-11-15T22:47:13.2470270Z remote: Compressing objects:  41% (371/903)
2020-11-15T22:47:13.2498940Z remote: Compressing objects:  42% (380/903)
2020-11-15T22:47:13.2537000Z remote: Compressing objects:  43% (389/903)
2020-11-15T22:47:13.2561150Z remote: Compressing objects:  44% (398/903)
2020-11-15T22:47:13.2580730Z remote: Compressing objects:  45% (407/903)
2020-11-15T22:47:13.2597460Z remote: Compressing objects:  46% (416/903)
2020-11-15T22:47:13.2610910Z remote: Compressing objects:  47% (425/903)
2020-11-15T22:47:13.2631960Z remote: Compressing objects:  48% (434/903)
2020-11-15T22:47:13.2654860Z remote: Compressing objects:  49% (443/903)
2020-11-15T22:47:13.2691420Z remote: Compressing objects:  50% (452/903)
2020-11-15T22:47:13.2743660Z remote: Compressing objects:  51% (461/903)
2020-11-15T22:47:13.2747590Z remote: Compressing objects:  52% (470/903)
2020-11-15T22:47:13.2759960Z remote: Compressing objects:  53% (479/903)
2020-11-15T22:47:13.2795110Z remote: Compressing objects:  54% (488/903)
2020-11-15T22:47:13.2808780Z remote: Compressing objects:  55% (497/903)
2020-11-15T22:47:13.2828520Z remote: Compressing objects:  56% (506/903)
2020-11-15T22:47:13.2837570Z remote: Compressing objects:  57% (515/903)
2020-11-15T22:47:13.2850480Z remote: Compressing objects:  58% (524/903)
2020-11-15T22:47:13.2890310Z remote: Compressing objects:  59% (533/903)
2020-11-15T22:47:13.2924270Z remote: Compressing objects:  60% (542/903)
2020-11-15T22:47:13.2988920Z remote: Compressing objects:  61% (551/903)
2020-11-15T22:47:13.3013720Z remote: Compressing objects:  62% (560/903)
2020-11-15T22:47:13.3058570Z remote: Compressing objects:  63% (569/903)
2020-11-15T22:47:13.3103240Z remote: Compressing objects:  64% (578/903)
2020-11-15T22:47:13.3137510Z remote: Compressing objects:  65% (587/903)
2020-11-15T22:47:13.3175460Z remote: Compressing objects:  66% (596/903)
2020-11-15T22:47:13.3196110Z remote: Compressing objects:  67% (606/903)
2020-11-15T22:47:13.3197040Z remote: Compressing objects:  68% (615/903)
2020-11-15T22:47:13.3197600Z remote: Compressing objects:  69% (624/903)
2020-11-15T22:47:13.3198160Z remote: Compressing objects:  70% (633/903)
2020-11-15T22:47:13.3198660Z remote: Compressing objects:  71% (642/903)
2020-11-15T22:47:13.3199070Z remote: Compressing objects:  72% (651/903)
2020-11-15T22:47:13.3199480Z remote: Compressing objects:  73% (660/903)
2020-11-15T22:47:13.3200190Z remote: Compressing objects:  74% (669/903)
2020-11-15T22:47:13.3200650Z remote: Compressing objects:  75% (678/903)
2020-11-15T22:47:13.3201350Z remote: Compressing objects:  76% (687/903)
2020-11-15T22:47:13.3202010Z remote: Compressing objects:  77% (696/903)
2020-11-15T22:47:13.3202670Z remote: Compressing objects:  78% (705/903)
2020-11-15T22:47:13.3203320Z remote: Compressing objects:  79% (714/903)
2020-11-15T22:47:13.3204000Z remote: Compressing objects:  80% (723/903)
2020-11-15T22:47:13.3204700Z remote: Compressing objects:  81% (732/903)
2020-11-15T22:47:13.3205350Z remote: Compressing objects:  82% (741/903)
2020-11-15T22:47:13.3205970Z remote: Compressing objects:  83% (750/903)
2020-11-15T22:47:13.3206620Z remote: Compressing objects:  84% (759/903)
2020-11-15T22:47:13.3207270Z remote: Compressing objects:  85% (768/903)
2020-11-15T22:47:13.3207910Z remote: Compressing objects:  86% (777/903)
2020-11-15T22:47:13.3208560Z remote: Compressing objects:  87% (786/903)
2020-11-15T22:47:13.3209200Z remote: Compressing objects:  88% (795/903)
2020-11-15T22:47:13.3231090Z remote: Compressing objects:  89% (804/903)
2020-11-15T22:47:13.3231650Z remote: Compressing objects:  90% (813/903)
2020-11-15T22:47:13.3232090Z remote: Compressing objects:  91% (822/903)
2020-11-15T22:47:13.3232780Z remote: Compressing objects:  92% (831/903)
2020-11-15T22:47:13.3233360Z remote: Compressing objects:  93% (840/903)
2020-11-15T22:47:13.3235200Z remote: Compressing objects:  94% (849/903)
2020-11-15T22:47:13.3238480Z remote: Compressing objects:  95% (858/903)
2020-11-15T22:47:13.3239070Z remote: Compressing objects:  96% (867/903)
2020-11-15T22:47:13.3239620Z remote: Compressing objects:  97% (876/903)
2020-11-15T22:47:13.3240020Z remote: Compressing objects:  98% (885/903)
2020-11-15T22:47:13.3240430Z remote: Compressing objects:  99% (894/903)
2020-11-15T22:47:13.3240840Z remote: Compressing objects: 100% (903/903)
2020-11-15T22:47:13.3241340Z remote: Compressing objects: 100% (903/903), done.
2020-11-15T22:47:13.3318500Z Receiving objects:   0% (1/1032)
2020-11-15T22:47:13.9577890Z Receiving objects:   1% (11/1032)
2020-11-15T22:47:13.9582170Z Receiving objects:   2% (21/1032)
2020-11-15T22:47:13.9584370Z Receiving objects:   3% (31/1032)
2020-11-15T22:47:13.9590290Z Receiving objects:   4% (42/1032)
2020-11-15T22:47:13.9593470Z Receiving objects:   5% (52/1032)
2020-11-15T22:47:13.9596000Z Receiving objects:   6% (62/1032)
2020-11-15T22:47:13.9598590Z Receiving objects:   7% (73/1032)
2020-11-15T22:47:13.9600740Z Receiving objects:   8% (83/1032)
2020-11-15T22:47:13.9602390Z Receiving objects:   9% (93/1032)
2020-11-15T22:47:13.9603960Z Receiving objects:  10% (104/1032)
2020-11-15T22:47:13.9639250Z Receiving objects:  11% (114/1032)
2020-11-15T22:47:13.9641650Z Receiving objects:  12% (124/1032)
2020-11-15T22:47:14.0145610Z Receiving objects:  13% (135/1032)
2020-11-15T22:47:14.0202120Z Receiving objects:  14% (145/1032)
2020-11-15T22:47:14.0203940Z Receiving objects:  15% (155/1032)
2020-11-15T22:47:14.0206250Z Receiving objects:  16% (166/1032)
2020-11-15T22:47:14.0208500Z Receiving objects:  17% (176/1032)
2020-11-15T22:47:14.0210870Z Receiving objects:  18% (186/1032)
2020-11-15T22:47:14.0212330Z Receiving objects:  19% (197/1032)
2020-11-15T22:47:14.0213170Z Receiving objects:  20% (207/1032)
2020-11-15T22:47:14.0213880Z Receiving objects:  21% (217/1032)
2020-11-15T22:47:14.0215620Z Receiving objects:  22% (228/1032)
2020-11-15T22:47:14.0216690Z Receiving objects:  23% (238/1032)
2020-11-15T22:47:14.0217930Z Receiving objects:  24% (248/1032)
2020-11-15T22:47:14.0219580Z Receiving objects:  25% (258/1032)
2020-11-15T22:47:14.0220720Z Receiving objects:  26% (269/1032)
2020-11-15T22:47:14.0222300Z Receiving objects:  27% (279/1032)
2020-11-15T22:47:14.0223600Z Receiving objects:  28% (289/1032)
2020-11-15T22:47:14.0226080Z Receiving objects:  29% (300/1032)
2020-11-15T22:47:14.0227210Z Receiving objects:  30% (310/1032)
2020-11-15T22:47:14.0229450Z Receiving objects:  31% (320/1032)
2020-11-15T22:47:14.0230110Z Receiving objects:  32% (331/1032)
2020-11-15T22:47:14.0230950Z Receiving objects:  33% (341/1032)
2020-11-15T22:47:14.0231710Z Receiving objects:  34% (351/1032)
2020-11-15T22:47:14.0232350Z Receiving objects:  35% (362/1032)
2020-11-15T22:47:14.0232990Z Receiving objects:  36% (372/1032)
2020-11-15T22:47:14.0233590Z Receiving objects:  37% (382/1032)
2020-11-15T22:47:14.0234290Z Receiving objects:  38% (393/1032)
2020-11-15T22:47:14.0234920Z Receiving objects:  39% (403/1032)
2020-11-15T22:47:14.0235510Z Receiving objects:  40% (413/1032)
2020-11-15T22:47:14.0236400Z Receiving objects:  41% (424/1032)
2020-11-15T22:47:14.0237000Z Receiving objects:  42% (434/1032)
2020-11-15T22:47:14.0237600Z Receiving objects:  43% (444/1032)
2020-11-15T22:47:14.0238190Z Receiving objects:  44% (455/1032)
2020-11-15T22:47:14.0238830Z Receiving objects:  45% (465/1032)
2020-11-15T22:47:14.0239370Z Receiving objects:  46% (475/1032)
2020-11-15T22:47:14.0239950Z Receiving objects:  47% (486/1032)
2020-11-15T22:47:14.0240630Z Receiving objects:  48% (496/1032)
2020-11-15T22:47:14.0241220Z Receiving objects:  49% (506/1032)
2020-11-15T22:47:14.0242060Z Receiving objects:  50% (516/1032)
2020-11-15T22:47:14.0243150Z Receiving objects:  51% (527/1032)
2020-11-15T22:47:14.0245420Z Receiving objects:  52% (537/1032)
2020-11-15T22:47:14.0247140Z Receiving objects:  53% (547/1032)
2020-11-15T22:47:14.0250290Z Receiving objects:  54% (558/1032)
2020-11-15T22:47:14.0251720Z Receiving objects:  55% (568/1032)
2020-11-15T22:47:14.0255230Z Receiving objects:  56% (578/1032)
2020-11-15T22:47:14.0255740Z Receiving objects:  57% (589/1032)
2020-11-15T22:47:14.0256110Z Receiving objects:  58% (599/1032)
2020-11-15T22:47:14.0256440Z Receiving objects:  59% (609/1032)
2020-11-15T22:47:14.0256800Z Receiving objects:  60% (620/1032)
2020-11-15T22:47:14.0257250Z Receiving objects:  61% (630/1032)
2020-11-15T22:47:14.0258190Z Receiving objects:  62% (640/1032)
2020-11-15T22:47:14.0259580Z Receiving objects:  63% (651/1032)
2020-11-15T22:47:14.0266210Z Receiving objects:  64% (661/1032)
2020-11-15T22:47:14.0266890Z Receiving objects:  65% (671/1032)
2020-11-15T22:47:14.0267920Z Receiving objects:  66% (682/1032)
2020-11-15T22:47:14.0268650Z Receiving objects:  67% (692/1032)
2020-11-15T22:47:14.0269480Z Receiving objects:  68% (702/1032)
2020-11-15T22:47:14.0270210Z Receiving objects:  69% (713/1032)
2020-11-15T22:47:14.0271510Z Receiving objects:  70% (723/1032)
2020-11-15T22:47:14.0272220Z Receiving objects:  71% (733/1032)
2020-11-15T22:47:14.0272910Z Receiving objects:  72% (744/1032)
2020-11-15T22:47:14.0273590Z Receiving objects:  73% (754/1032)
2020-11-15T22:47:14.0274310Z Receiving objects:  74% (764/1032)
2020-11-15T22:47:14.0274990Z Receiving objects:  75% (774/1032)
2020-11-15T22:47:14.0275710Z Receiving objects:  76% (785/1032)
2020-11-15T22:47:14.0276400Z Receiving objects:  77% (795/1032)
2020-11-15T22:47:14.0277070Z Receiving objects:  78% (805/1032)
2020-11-15T22:47:14.0277740Z Receiving objects:  79% (816/1032)
2020-11-15T22:47:14.0278470Z Receiving objects:  80% (826/1032)
2020-11-15T22:47:14.0279140Z Receiving objects:  81% (836/1032)
2020-11-15T22:47:14.0280230Z Receiving objects:  82% (847/1032)
2020-11-15T22:47:14.0281000Z Receiving objects:  83% (857/1032)
2020-11-15T22:47:14.0282470Z Receiving objects:  84% (867/1032)
2020-11-15T22:47:14.0282940Z Receiving objects:  85% (878/1032)
2020-11-15T22:47:14.0284310Z Receiving objects:  86% (888/1032)
2020-11-15T22:47:14.0284630Z Receiving objects:  87% (898/1032)
2020-11-15T22:47:14.0284990Z Receiving objects:  88% (909/1032)
2020-11-15T22:47:14.0285340Z Receiving objects:  89% (919/1032)
2020-11-15T22:47:14.0285680Z Receiving objects:  90% (929/1032)
2020-11-15T22:47:14.0286010Z Receiving objects:  91% (940/1032)
2020-11-15T22:47:14.0286350Z Receiving objects:  92% (950/1032)
2020-11-15T22:47:14.0286680Z Receiving objects:  93% (960/1032)
2020-11-15T22:47:14.0286990Z Receiving objects:  94% (971/1032)
2020-11-15T22:47:14.0287340Z Receiving objects:  95% (981/1032)
2020-11-15T22:47:14.0287650Z Receiving objects:  96% (991/1032)
2020-11-15T22:47:14.0288000Z Receiving objects:  97% (1002/1032)
2020-11-15T22:47:14.0288420Z Receiving objects:  98% (1012/1032)
2020-11-15T22:47:14.0288780Z Receiving objects:  99% (1022/1032)
2020-11-15T22:47:14.0290040Z remote: Total 1032 (delta 262), reused 422 (delta 104), pack-reused 0
2020-11-15T22:47:14.0290590Z Receiving objects: 100% (1032/1032)
2020-11-15T22:47:14.0290990Z Receiving objects: 100% (1032/1032), 1.27 MiB | 10.13 MiB/s, done.
2020-11-15T22:47:14.0291340Z Resolving deltas:   0% (0/262)
2020-11-15T22:47:14.0291680Z Resolving deltas:   1% (3/262)
2020-11-15T22:47:14.0292000Z Resolving deltas:   2% (6/262)
2020-11-15T22:47:14.0292330Z Resolving deltas:   3% (8/262)
2020-11-15T22:47:14.0292750Z Resolving deltas:   4% (11/262)
2020-11-15T22:47:14.0293120Z Resolving deltas:   5% (14/262)
2020-11-15T22:47:14.0293460Z Resolving deltas:   6% (16/262)
2020-11-15T22:47:14.0293800Z Resolving deltas:   7% (19/262)
2020-11-15T22:47:14.0294100Z Resolving deltas:   8% (21/262)
2020-11-15T22:47:14.0294440Z Resolving deltas:   9% (24/262)
2020-11-15T22:47:14.0294780Z Resolving deltas:  10% (27/262)
2020-11-15T22:47:14.0295200Z Resolving deltas:  11% (29/262)
2020-11-15T22:47:14.0295560Z Resolving deltas:  12% (32/262)
2020-11-15T22:47:14.0295900Z Resolving deltas:  13% (35/262)
2020-11-15T22:47:14.0296360Z Resolving deltas:  14% (37/262)
2020-11-15T22:47:14.0296660Z Resolving deltas:  15% (40/262)
2020-11-15T22:47:14.0297070Z Resolving deltas:  16% (42/262)
2020-11-15T22:47:14.0297370Z Resolving deltas:  17% (45/262)
2020-11-15T22:47:14.0297670Z Resolving deltas:  18% (48/262)
2020-11-15T22:47:14.0298020Z Resolving deltas:  19% (50/262)
2020-11-15T22:47:14.0298320Z Resolving deltas:  20% (53/262)
2020-11-15T22:47:14.0298660Z Resolving deltas:  21% (56/262)
2020-11-15T22:47:14.0298990Z Resolving deltas:  22% (58/262)
2020-11-15T22:47:14.0299320Z Resolving deltas:  23% (61/262)
2020-11-15T22:47:14.0299660Z Resolving deltas:  24% (63/262)
2020-11-15T22:47:14.0299950Z Resolving deltas:  25% (66/262)
2020-11-15T22:47:14.0300290Z Resolving deltas:  26% (69/262)
2020-11-15T22:47:14.0300700Z Resolving deltas:  27% (71/262)
2020-11-15T22:47:14.0301060Z Resolving deltas:  28% (74/262)
2020-11-15T22:47:14.0301400Z Resolving deltas:  29% (76/262)
2020-11-15T22:47:14.0301720Z Resolving deltas:  30% (79/262)
2020-11-15T22:47:14.0302530Z Resolving deltas:  31% (82/262)
2020-11-15T22:47:14.0302830Z Resolving deltas:  32% (84/262)
2020-11-15T22:47:14.0303170Z Resolving deltas:  33% (87/262)
2020-11-15T22:47:14.0303510Z Resolving deltas:  34% (90/262)
2020-11-15T22:47:14.0303840Z Resolving deltas:  35% (92/262)
2020-11-15T22:47:14.0304230Z Resolving deltas:  36% (95/262)
2020-11-15T22:47:14.0304650Z Resolving deltas:  37% (97/262)
2020-11-15T22:47:14.0304990Z Resolving deltas:  38% (100/262)
2020-11-15T22:47:14.0305320Z Resolving deltas:  39% (103/262)
2020-11-15T22:47:14.0305790Z Resolving deltas:  40% (105/262)
2020-11-15T22:47:14.0307500Z Resolving deltas:  41% (108/262)
2020-11-15T22:47:14.0307830Z Resolving deltas:  42% (111/262)
2020-11-15T22:47:14.0308140Z Resolving deltas:  43% (113/262)
2020-11-15T22:47:14.0308920Z Resolving deltas:  44% (116/262)
2020-11-15T22:47:14.0309290Z Resolving deltas:  45% (118/262)
2020-11-15T22:47:14.0309600Z Resolving deltas:  46% (121/262)
2020-11-15T22:47:14.0310390Z Resolving deltas:  47% (124/262)
2020-11-15T22:47:14.0310710Z Resolving deltas:  48% (126/262)
2020-11-15T22:47:14.0311060Z Resolving deltas:  49% (129/262)
2020-11-15T22:47:14.0311410Z Resolving deltas:  50% (132/262)
2020-11-15T22:47:14.0311710Z Resolving deltas:  51% (134/262)
2020-11-15T22:47:14.0312040Z Resolving deltas:  52% (137/262)
2020-11-15T22:47:14.0312370Z Resolving deltas:  53% (139/262)
2020-11-15T22:47:14.0312700Z Resolving deltas:  54% (142/262)
2020-11-15T22:47:14.0313050Z Resolving deltas:  55% (145/262)
2020-11-15T22:47:14.0313380Z Resolving deltas:  56% (147/262)
2020-11-15T22:47:14.0313720Z Resolving deltas:  57% (150/262)
2020-11-15T22:47:14.0314050Z Resolving deltas:  58% (152/262)
2020-11-15T22:47:14.0314350Z Resolving deltas:  59% (155/262)
2020-11-15T22:47:14.0314690Z Resolving deltas:  60% (158/262)
2020-11-15T22:47:14.0315380Z Resolving deltas:  61% (160/262)
2020-11-15T22:47:14.0315780Z Resolving deltas:  62% (163/262)
2020-11-15T22:47:14.0316120Z Resolving deltas:  63% (166/262)
2020-11-15T22:47:14.0316520Z Resolving deltas:  64% (168/262)
2020-11-15T22:47:14.0316850Z Resolving deltas:  65% (171/262)
2020-11-15T22:47:14.0317140Z Resolving deltas:  66% (173/262)
2020-11-15T22:47:14.0317450Z Resolving deltas:  67% (176/262)
2020-11-15T22:47:14.0317760Z Resolving deltas:  68% (179/262)
2020-11-15T22:47:14.0318060Z Resolving deltas:  69% (181/262)
2020-11-15T22:47:14.0318370Z Resolving deltas:  70% (184/262)
2020-11-15T22:47:14.0318670Z Resolving deltas:  71% (187/262)
2020-11-15T22:47:14.0319050Z Resolving deltas:  72% (189/262)
2020-11-15T22:47:14.0319360Z Resolving deltas:  73% (192/262)
2020-11-15T22:47:14.0319650Z Resolving deltas:  74% (194/262)
2020-11-15T22:47:14.0319950Z Resolving deltas:  75% (197/262)
2020-11-15T22:47:14.0320260Z Resolving deltas:  76% (200/262)
2020-11-15T22:47:14.0320630Z Resolving deltas:  77% (202/262)
2020-11-15T22:47:14.0320940Z Resolving deltas:  78% (205/262)
2020-11-15T22:47:14.0321270Z Resolving deltas:  79% (207/262)
2020-11-15T22:47:14.0321700Z Resolving deltas:  80% (210/262)
2020-11-15T22:47:14.0321990Z Resolving deltas:  81% (213/262)
2020-11-15T22:47:14.0322330Z Resolving deltas:  82% (215/262)
2020-11-15T22:47:14.0322660Z Resolving deltas:  83% (218/262)
2020-11-15T22:47:14.0322960Z Resolving deltas:  84% (221/262)
2020-11-15T22:47:14.0323260Z Resolving deltas:  85% (223/262)
2020-11-15T22:47:14.0323560Z Resolving deltas:  86% (226/262)
2020-11-15T22:47:14.0323860Z Resolving deltas:  87% (228/262)
2020-11-15T22:47:14.0324160Z Resolving deltas:  88% (231/262)
2020-11-15T22:47:14.0324450Z Resolving deltas:  89% (234/262)
2020-11-15T22:47:14.0324750Z Resolving deltas:  90% (236/262)
2020-11-15T22:47:14.0325050Z Resolving deltas:  91% (239/262)
2020-11-15T22:47:14.0325360Z Resolving deltas:  92% (242/262)
2020-11-15T22:47:14.0325690Z Resolving deltas:  93% (244/262)
2020-11-15T22:47:14.0326090Z Resolving deltas:  94% (247/262)
2020-11-15T22:47:14.0326420Z Resolving deltas:  95% (249/262)
2020-11-15T22:47:14.0326710Z Resolving deltas:  96% (252/262)
2020-11-15T22:47:14.0327460Z Resolving deltas:  97% (255/262)
2020-11-15T22:47:14.0327800Z Resolving deltas:  98% (257/262)
2020-11-15T22:47:14.0328130Z Resolving deltas:  99% (260/262)
2020-11-15T22:47:14.0328460Z Resolving deltas: 100% (262/262)
2020-11-15T22:47:14.0328780Z Resolving deltas: 100% (262/262), done.
2020-11-15T22:47:14.0329280Z From https://github.com/pointfreeco/pointfreeco
2020-11-15T22:47:14.0330660Z  * [new ref]         fab6d0cc57614314d79e4bd2307f4273a474b5b5 -> origin/main
2020-11-15T22:47:14.0331510Z ##[endgroup]
2020-11-15T22:47:14.0332010Z ##[group]Determining the checkout info
2020-11-15T22:47:14.0332680Z ##[endgroup]
2020-11-15T22:47:14.0333140Z ##[group]Checking out the ref
2020-11-15T22:47:14.0334100Z [command]/usr/local/bin/git checkout --progress --force -B main refs/remotes/origin/main
2020-11-15T22:47:14.0335380Z Switched to a new branch 'main'
2020-11-15T22:47:14.0336270Z Branch 'main' set up to track remote branch 'main' from 'origin'.
2020-11-15T22:47:14.1131060Z ##[endgroup]
2020-11-15T22:47:14.1222050Z [command]/usr/local/bin/git log -1 --format='%H'
2020-11-15T22:47:14.1289980Z 'fab6d0cc57614314d79e4bd2307f4273a474b5b5'
2020-11-15T22:47:29.8333940Z ##[endgroup]
2020-11-15T22:47:36.0836990Z createuser --superuser pointfreeco || true
2020-11-15T22:47:36.2586900Z createdb --owner pointfreeco pointfreeco_development || true
2020-11-15T22:47:36.6354900Z createdb --owner pointfreeco pointfreeco_test || true
2020-11-15T22:48:51.4921290Z Fetching https://github.com/pointfreeco/Ccmark.git
2020-11-15T22:49:02.4312250Z Fetching https://github.com/pointfreeco/swift-html.git
2020-11-15T22:49:12.4267310Z Fetching https://github.com/pointfreeco/swift-prelude.git
2020-11-15T22:49:15.6810050Z Fetching https://github.com/pointfreeco/swift-tagged.git
2020-11-15T22:49:18.0842000Z Fetching https://github.com/pointfreeco/swift-web.git
2020-11-15T22:49:19.7171070Z Fetching https://github.com/apple/swift-nio-extras.git
2020-11-15T22:49:22.1611360Z Fetching https://github.com/IBM-Swift/BlueCryptor.git
2020-11-15T22:49:24.6106990Z Fetching https://github.com/apple/swift-nio.git
2020-11-15T22:49:30.1830010Z Fetching https://github.com/pointfreeco/swift-snapshot-testing.git
2020-11-15T22:49:34.5350090Z Fetching https://github.com/vapor-community/postgresql.git
2020-11-15T22:49:36.5919150Z Fetching https://github.com/ianpartridge/swift-backtrace.git
2020-11-15T22:49:37.2866500Z Fetching https://github.com/apple/swift-log.git
2020-11-15T22:49:42.7992130Z Fetching https://github.com/vapor/core.git
2020-11-15T22:49:45.7032650Z Fetching https://github.com/vapor/node.git
2020-11-15T22:49:47.4587710Z Fetching https://github.com/vapor-community/cpostgresql.git
2020-11-15T22:49:53.7857470Z Fetching https://github.com/vapor/debugging.git
2020-11-15T22:49:56.0633730Z Fetching https://github.com/vapor/bits.git
2020-11-15T22:50:12.2453830Z Cloning https://github.com/pointfreeco/swift-web.git
2020-11-15T22:50:18.7218050Z Resolving https://github.com/pointfreeco/swift-web.git at 148acf4
2020-11-15T22:50:19.8626910Z Cloning https://github.com/vapor/core.git
2020-11-15T22:50:25.4328920Z Resolving https://github.com/vapor/core.git at 2.2.1
2020-11-15T22:50:28.9098080Z Cloning https://github.com/apple/swift-log.git
2020-11-15T22:50:32.6443710Z Resolving https://github.com/apple/swift-log.git at 1.4.0
2020-11-15T22:50:34.2068150Z Cloning https://github.com/vapor/node.git
2020-11-15T22:50:38.0626410Z Resolving https://github.com/vapor/node.git at 2.1.5
2020-11-15T22:50:38.4546210Z Cloning https://github.com/ianpartridge/swift-backtrace.git
2020-11-15T22:50:42.9248190Z Resolving https://github.com/ianpartridge/swift-backtrace.git at 1.1.0
2020-11-15T22:50:45.3436370Z Cloning https://github.com/IBM-Swift/BlueCryptor.git
2020-11-15T22:50:48.7101610Z Resolving https://github.com/IBM-Swift/BlueCryptor.git at 1.0.32
2020-11-15T22:50:48.9487290Z Cloning https://github.com/vapor-community/cpostgresql.git
2020-11-15T22:50:51.5191900Z Resolving https://github.com/vapor-community/cpostgresql.git at 2.1.0
2020-11-15T22:50:51.9480540Z Cloning https://github.com/pointfreeco/Ccmark.git
2020-11-15T22:50:54.5262910Z Resolving https://github.com/pointfreeco/Ccmark.git at main
2020-11-15T22:50:54.9377860Z Cloning https://github.com/vapor/bits.git
2020-11-15T22:50:57.4338740Z Resolving https://github.com/vapor/bits.git at 1.1.1
2020-11-15T22:50:57.6449720Z Cloning https://github.com/vapor/debugging.git
2020-11-15T22:51:00.5019060Z Resolving https://github.com/vapor/debugging.git at 1.1.1
2020-11-15T22:51:00.9192370Z Cloning https://github.com/apple/swift-nio-extras.git
2020-11-15T22:51:04.9736690Z Resolving https://github.com/apple/swift-nio-extras.git at 1.7.0
2020-11-15T22:51:05.3796360Z Cloning https://github.com/pointfreeco/swift-html.git
2020-11-15T22:51:06.7127410Z Resolving https://github.com/pointfreeco/swift-html.git at 3a1b7e4
2020-11-15T22:51:14.5874490Z Cloning https://github.com/pointfreeco/swift-snapshot-testing.git
2020-11-15T22:51:16.0235630Z Resolving https://github.com/pointfreeco/swift-snapshot-testing.git at 1.8.2
2020-11-15T22:51:16.3919950Z Cloning https://github.com/apple/swift-nio.git
2020-11-15T22:51:19.2571280Z Resolving https://github.com/apple/swift-nio.git at 2.23.0
2020-11-15T22:51:19.7620250Z Cloning https://github.com/vapor-community/postgresql.git
2020-11-15T22:51:20.3838410Z Resolving https://github.com/vapor-community/postgresql.git at 2.1.2
2020-11-15T22:51:20.5805900Z Cloning https://github.com/pointfreeco/swift-tagged.git
2020-11-15T22:51:20.8778500Z Resolving https://github.com/pointfreeco/swift-tagged.git at fde36b6
2020-11-15T22:51:21.0452490Z Cloning https://github.com/pointfreeco/swift-prelude.git
2020-11-15T22:51:21.1219070Z Resolving https://github.com/pointfreeco/swift-prelude.git at 9240a1f
2020-11-15T22:51:28.1668700Z 'CPostgreSQL' /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/cpostgresql: warning: ignoring declared target(s) 'CPostgreSQL' in the system package
2020-11-15T22:51:29.0227280Z [1/13] Compiling CNIOWindows WSAStartup.c
2020-11-15T22:51:29.0289230Z [2/13] Compiling CNIOWindows shim.c
2020-11-15T22:51:29.0511240Z [3/15] Compiling CNIOLinux shim.c
2020-11-15T22:51:29.8569010Z [4/48] Compiling CNIOSHA1 c_nio_sha1.c
2020-11-15T22:51:32.3769290Z [5/84] Compiling Prelude Alt.swift
2020-11-15T22:51:32.4404480Z [6/85] Merging module libc
2020-11-15T22:51:32.5982090Z [7/87] Compiling PathIndexable PathIndexable+Subscripting.swift
2020-11-15T22:51:32.7110410Z [8/87] Compiling PathIndexable PathIndexable.swift
2020-11-15T22:51:32.7538450Z [9/88] Merging module PathIndexable
2020-11-15T22:51:32.8692700Z [10/91] Compiling Logging LogHandler.swift
2020-11-15T22:51:33.0667500Z [11/91] Compiling Logging Locks.swift
2020-11-15T22:51:33.4358610Z [12/91] Compiling Logging Logging.swift
2020-11-15T22:51:33.5975240Z [13/92] Merging module Logging
2020-11-15T22:51:34.9355270Z [14/105] Compiling Html Node.swift
2020-11-15T22:51:34.9455770Z [15/105] Compiling Html Tag.swift
2020-11-15T22:51:34.9456700Z [16/105] Compiling Html XmlRender.swift
2020-11-15T22:51:34.9774160Z [17/105] Compiling Html Html4.swift
2020-11-15T22:51:34.9774840Z [18/105] Compiling Html HtmlRender.swift
2020-11-15T22:51:34.9776820Z [19/105] Compiling Html MediaType.swift
2020-11-15T22:51:35.1894860Z [20/105] Compiling Html DebugXmlRender.swift
2020-11-15T22:51:35.1896190Z [21/105] Compiling Html Elements.swift
2020-11-15T22:51:35.1896610Z [22/105] Compiling Html Events.swift
2020-11-15T22:51:37.4943680Z [23/105] Compiling Html Aria.swift
2020-11-15T22:51:37.5044370Z [24/105] Compiling Html Attributes.swift
2020-11-15T22:51:37.5094470Z [25/105] Compiling Html ChildOf.swift
2020-11-15T22:51:37.5224120Z [26/105] Compiling Html DebugRender.swift
2020-11-15T22:51:37.6428540Z [32/105] Compiling Prelude KeyPath.swift
2020-11-15T22:51:37.6529910Z [33/105] Compiling Prelude Monoid.swift
2020-11-15T22:51:37.6572340Z [34/105] Compiling Prelude NearSemiring.swift
2020-11-15T22:51:37.6595630Z [35/105] Compiling Prelude Never.swift
2020-11-15T22:51:37.6599080Z [36/105] Compiling Prelude Operators.swift
2020-11-15T22:51:37.6599870Z [37/105] Compiling Prelude Optional.swift
2020-11-15T22:51:37.6602860Z [38/105] Compiling Prelude Parallel.swift
2020-11-15T22:51:37.6610400Z [39/105] Compiling Prelude Plus.swift
2020-11-15T22:51:37.6611200Z [40/105] Compiling Prelude PrecedenceGroups.swift
2020-11-15T22:51:37.6611890Z [41/105] Compiling Prelude Ring.swift
2020-11-15T22:51:37.6612520Z [42/105] Compiling Prelude Semigroup.swift
2020-11-15T22:51:37.6613170Z [43/105] Compiling Prelude Semiring.swift
2020-11-15T22:51:37.6613810Z [44/105] Compiling Prelude Sequence.swift
2020-11-15T22:51:37.6614410Z [45/105] Compiling Prelude Set.swift
2020-11-15T22:51:37.6626050Z [46/105] Compiling Prelude String.swift
2020-11-15T22:51:37.6627250Z [47/105] Compiling Prelude Strong.swift
2020-11-15T22:51:37.6628570Z [48/105] Compiling Prelude Tuple.swift
2020-11-15T22:51:37.6631960Z [49/105] Compiling Prelude Unit.swift
2020-11-15T22:51:38.2831000Z [55/106] Compiling Prelude Func.swift
2020-11-15T22:51:38.2929040Z [56/106] Compiling Prelude Function.swift
2020-11-15T22:51:38.2930030Z [57/106] Compiling Prelude HeytingAlgebra.swift
2020-11-15T22:51:38.2930720Z [58/106] Compiling Prelude Hole.swift
2020-11-15T22:51:38.2931290Z [59/106] Compiling Prelude IO.swift
2020-11-15T22:51:38.4901330Z [60/107] Merging module Prelude
2020-11-15T22:51:38.4918750Z [61/107] Merging module Tagged
2020-11-15T22:51:38.7383780Z [62/109] Compiling TaggedTime TaggedTime.swift
2020-11-15T22:51:38.7763010Z [63/110] Merging module Debugging
2020-11-15T22:51:39.0638030Z [68/112] Compiling Tuple Tuple.swift
2020-11-15T22:51:39.0979480Z [69/113] Merging module Html
2020-11-15T22:51:39.2361580Z [70/114] Merging module TaggedTime
2020-11-15T22:51:39.3346420Z [71/115] Compiling EmailAddress EmailAddress.swift
2020-11-15T22:51:39.4942020Z [73/117] Merging module Tuple
2020-11-15T22:51:39.5655840Z [74/118] Merging module TaggedMoney
2020-11-15T22:51:44.7753530Z [99/119] Compiling HtmlPlainTextPrint HtmlPlainTextPrint.swift
2020-11-15T22:51:44.9378410Z [110/122] Merging module EmailAddress
2020-11-15T22:51:45.1407120Z [111/126] Merging module View
2020-11-15T22:51:45.2274120Z [112/127] Compiling DecodableRequest DecodableRequest.swift
2020-11-15T22:51:45.3515790Z [114/128] Compiling Either Nested.swift
2020-11-15T22:51:45.3955450Z [115/128] Merging module SnapshotTesting
2020-11-15T22:51:45.5566620Z [116/139] Merging module DecodableRequest
2020-11-15T22:51:46.0923060Z [117/140] Compiling Cryptor Digest.swift
2020-11-15T22:51:46.1702830Z [118/140] Compiling HtmlSnapshotTesting HtmlSnapshotTesting.swift
2020-11-15T22:51:46.1817240Z [119/141] Compiling Cryptor Cryptor.swift
2020-11-15T22:51:46.5731270Z [120/142] Merging module Either
2020-11-15T22:51:46.7837900Z [121/152] Merging module HtmlSnapshotTesting
2020-11-15T22:51:47.3077560Z [122/173] Compiling Css Appearance.swift
2020-11-15T22:51:47.3178980Z [123/173] Compiling Css Background.swift
2020-11-15T22:51:47.3280440Z [124/173] Compiling Css Border.swift
2020-11-15T22:51:47.4084060Z [125/173] Compiling Css Display.swift
2020-11-15T22:51:47.4159600Z [126/173] Compiling Css Elements.swift
2020-11-15T22:51:47.5041860Z [128/174] Compiling Css Config.swift
2020-11-15T22:51:47.5147960Z [129/174] Compiling Css CssSelector.swift
2020-11-15T22:51:48.0860990Z [130/174] Compiling Css Box.swift
2020-11-15T22:51:48.0861470Z [131/174] Compiling Css Color.swift
2020-11-15T22:51:48.0962710Z [132/174] Compiling Css Common.swift
2020-11-15T22:51:48.1068580Z [136/175] Merging module HtmlPlainTextPrint
2020-11-15T22:51:48.1169850Z [137/194] Compiling Bits Aliases.swift
2020-11-15T22:51:48.1271180Z [138/194] Compiling Bits Base64Encoder.swift
2020-11-15T22:51:48.1372600Z [139/194] Compiling Bits Byte+Alphabet.swift
2020-11-15T22:51:48.1440050Z [140/194] Compiling Bits Bytes+Base64.swift
2020-11-15T22:51:48.1441730Z [141/194] Compiling Bits Bytes+Hex.swift
2020-11-15T22:51:48.1442350Z [142/194] Merging module Optics
2020-11-15T22:51:48.1443670Z [143/196] Compiling Bits Byte+Random.swift
2020-11-15T22:51:48.1445650Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/BlueCryptor/Sources/Cryptor/StreamCryptor.swift:188:21: warning: static property 'none' produces an empty option set
2020-11-15T22:51:48.1446690Z                 public static let none = Options(rawValue: 0)
2020-11-15T22:51:48.1447730Z                                   ^
2020-11-15T22:51:48.1448600Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/BlueCryptor/Sources/Cryptor/StreamCryptor.swift:188:21: note: use [] to silence this warning
2020-11-15T22:51:48.1449490Z                 public static let none = Options(rawValue: 0)
2020-11-15T22:51:48.1449840Z                                   ^             ~~~~~~~~~~~~~
2020-11-15T22:51:48.1450350Z                                                 ([])
2020-11-15T22:51:48.1450940Z [144/196] Compiling Bits Byte+UTF8Numbers.swift
2020-11-15T22:51:48.1453370Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/BlueCryptor/Sources/Cryptor/StreamCryptor.swift:188:21: warning: static property 'none' produces an empty option set
2020-11-15T22:51:48.1456760Z                 public static let none = Options(rawValue: 0)
2020-11-15T22:51:48.1457320Z                                   ^
2020-11-15T22:51:48.1458210Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/BlueCryptor/Sources/Cryptor/StreamCryptor.swift:188:21: note: use [] to silence this warning
2020-11-15T22:51:48.1461770Z                 public static let none = Options(rawValue: 0)
2020-11-15T22:51:48.1462440Z                                   ^             ~~~~~~~~~~~~~
2020-11-15T22:51:48.1462930Z                                                 ([])
2020-11-15T22:51:48.1464180Z [145/196] Compiling Bits ByteSequence+Conversions.swift
2020-11-15T22:51:48.1466070Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/BlueCryptor/Sources/Cryptor/StreamCryptor.swift:188:21: warning: static property 'none' produces an empty option set
2020-11-15T22:51:48.1472400Z                 public static let none = Options(rawValue: 0)
2020-11-15T22:51:48.1473090Z                                   ^
2020-11-15T22:51:48.1473990Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/BlueCryptor/Sources/Cryptor/StreamCryptor.swift:188:21: note: use [] to silence this warning
2020-11-15T22:51:48.1475120Z                 public static let none = Options(rawValue: 0)
2020-11-15T22:51:48.1475740Z                                   ^             ~~~~~~~~~~~~~
2020-11-15T22:51:48.1508730Z                                                 ([])
2020-11-15T22:51:48.1512350Z [146/197] Compiling Backtrace Backtrace.swift
2020-11-15T22:51:48.3066010Z [147/197] Compiling Bits Bytes+Percent.swift
2020-11-15T22:51:48.3167740Z [148/197] Compiling Bits BytesConvertible.swift
2020-11-15T22:51:48.3168520Z [149/197] Compiling Bits Data+BytesConvertible.swift
2020-11-15T22:51:48.3268670Z [150/197] Compiling Bits HexEncoder.swift
2020-11-15T22:51:48.3370130Z [151/197] Compiling Bits Operators.swift
2020-11-15T22:51:48.3557330Z [152/197] Compiling Backtrace Demangle.swift
2020-11-15T22:51:48.4336080Z [153/198] Merging module Backtrace
2020-11-15T22:51:48.5779940Z [154/200] Merging module Cryptor
2020-11-15T22:51:48.6104100Z [155/200] Compiling CNIOLinux ifaddrs-android.c
2020-11-15T22:51:48.8315570Z [156/200] Compiling CNIOHTTPParser c_nio_http_parser.c
2020-11-15T22:51:48.8599220Z [157/200] Compiling CNIOExtrasZlib empty.c
2020-11-15T22:51:48.9323970Z [158/200] Compiling CNIODarwin shim.c
2020-11-15T22:51:49.3163210Z [164/200] Compiling UrlFormEncoding UrlFormEncoding.swift
2020-11-15T22:51:49.6988210Z [165/200] Compiling Bits String+BytesConvertible.swift
2020-11-15T22:51:49.7062000Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/swift-web/Sources/Css/Render.swift:293:20: warning: the enum case has a single tuple as an associated value, but there are several patterns here, implicitly tupling the patterns and trying to match that instead
2020-11-15T22:51:49.7063470Z     case let .right(k, v):
2020-11-15T22:51:49.7063930Z                    ^
2020-11-15T22:51:49.7064870Z [166/200] Compiling Bits UnsignedInteger+BytesConvertible.swift
2020-11-15T22:51:49.7067000Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/swift-web/Sources/Css/Render.swift:293:20: warning: the enum case has a single tuple as an associated value, but there are several patterns here, implicitly tupling the patterns and trying to match that instead
2020-11-15T22:51:49.7068250Z     case let .right(k, v):
2020-11-15T22:51:49.7068710Z                    ^
2020-11-15T22:51:49.7069390Z [167/200] Compiling Bits UnsignedInteger+Shifting.swift
2020-11-15T22:51:49.7071360Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/swift-web/Sources/Css/Render.swift:293:20: warning: the enum case has a single tuple as an associated value, but there are several patterns here, implicitly tupling the patterns and trying to match that instead
2020-11-15T22:51:49.7072630Z     case let .right(k, v):
2020-11-15T22:51:49.7073080Z                    ^
2020-11-15T22:51:49.7074250Z [168/200] Compiling Css Stylesheet.swift
2020-11-15T22:51:49.7076190Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/swift-web/Sources/Css/Render.swift:293:20: warning: the enum case has a single tuple as an associated value, but there are several patterns here, implicitly tupling the patterns and trying to match that instead
2020-11-15T22:51:49.7077530Z     case let .right(k, v):
2020-11-15T22:51:49.7077980Z                    ^
2020-11-15T22:51:49.7078460Z [169/200] Compiling Css Text.swift
2020-11-15T22:51:49.7080230Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/swift-web/Sources/Css/Render.swift:293:20: warning: the enum case has a single tuple as an associated value, but there are several patterns here, implicitly tupling the patterns and trying to match that instead
2020-11-15T22:51:49.7082110Z     case let .right(k, v):
2020-11-15T22:51:49.7082570Z                    ^
2020-11-15T22:51:49.7216910Z [170/200] Compiling UrlFormEncoding UrlFormDecoder.swift
2020-11-15T22:51:49.7258920Z [173/200] Compiling Bits Byte+ControlCharacters.swift
2020-11-15T22:51:49.7259910Z [174/200] Compiling Bits Byte+Convenience.swift
2020-11-15T22:51:49.7260700Z [175/200] Compiling Bits Byte+PatternMatching.swift
2020-11-15T22:51:49.9205210Z [176/201] Merging module Css
2020-11-15T22:51:51.0993170Z [178/202] Merging module UrlFormEncoding
2020-11-15T22:51:51.2992290Z [179/203] Compiling HtmlCssSupport Support.swift
2020-11-15T22:51:51.4663950Z [180/204] Merging module HtmlCssSupport
2020-11-15T22:51:52.5418180Z [181/221] Compiling FunctionalCss Align.swift
2020-11-15T22:51:52.5454840Z [182/221] Compiling FunctionalCss Border.swift
2020-11-15T22:51:52.5508870Z [183/221] Compiling FunctionalCss Breakpoint.swift
2020-11-15T22:51:52.5522020Z [184/221] Compiling FunctionalCss Cursor.swift
2020-11-15T22:51:52.5611700Z [185/221] Compiling FunctionalCss DesignSystems.swift
2020-11-15T22:51:52.6983610Z [186/221] Compiling FunctionalCss Hide.swift
2020-11-15T22:51:52.7034880Z [187/221] Compiling FunctionalCss Layout.swift
2020-11-15T22:51:52.7035850Z [188/221] Compiling FunctionalCss Position.swift
2020-11-15T22:51:52.7036650Z [189/221] Compiling FunctionalCss Size.swift
2020-11-15T22:51:52.9611420Z [190/221] Compiling FunctionalCss Spacing.swift
2020-11-15T22:51:52.9612940Z [191/221] Compiling FunctionalCss TODO.swift
2020-11-15T22:51:52.9613810Z [192/221] Compiling FunctionalCss TypeScale.swift
2020-11-15T22:51:52.9614910Z [193/221] Compiling FunctionalCss Typography.swift
2020-11-15T22:51:52.9980560Z [194/221] Compiling FunctionalCss Display.swift
2020-11-15T22:51:52.9981430Z [195/221] Compiling FunctionalCss Flex.swift
2020-11-15T22:51:53.0082860Z [196/221] Compiling FunctionalCss FlexGrid.swift
2020-11-15T22:51:53.0120360Z [197/221] Compiling FunctionalCss GridHelpers.swift
2020-11-15T22:51:53.3046210Z [198/222] Merging module FunctionalCss
2020-11-15T22:51:53.5238480Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/bits/Sources/Bits/Data+BytesConvertible.swift:6:22: warning: initialization of 'UnsafeMutableBufferPointer<Byte>' (aka 'UnsafeMutableBufferPointer<UInt8>') results in a dangling buffer pointer
2020-11-15T22:51:53.5250590Z         let buffer = UnsafeMutableBufferPointer(start: &array, count: count)
2020-11-15T22:51:53.5251350Z                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:51:53.5255330Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/bits/Sources/Bits/Data+BytesConvertible.swift:6:56: note: implicit argument conversion from 'Bytes' (aka 'Array<UInt8>') to 'UnsafeMutablePointer<Byte>?' (aka 'Optional<UnsafeMutablePointer<UInt8>>') produces a pointer valid only for the duration of the call to 'init(start:count:)'
2020-11-15T22:51:53.5259530Z         let buffer = UnsafeMutableBufferPointer(start: &array, count: count)
2020-11-15T22:51:53.5260320Z                                                        ^~~~~~
2020-11-15T22:51:53.5263470Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/bits/Sources/Bits/Data+BytesConvertible.swift:6:56: note: use the 'withUnsafeMutableBufferPointer' method on Array in order to explicitly convert argument to buffer pointer valid for a defined scope
2020-11-15T22:51:53.5265300Z         let buffer = UnsafeMutableBufferPointer(start: &array, count: count)
2020-11-15T22:51:53.5266050Z                                                        ^
2020-11-15T22:51:53.5268210Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/bits/Sources/Bits/Data+BytesConvertible.swift:6:22: warning: initialization of 'UnsafeMutableBufferPointer<Byte>' (aka 'UnsafeMutableBufferPointer<UInt8>') results in a dangling buffer pointer
2020-11-15T22:51:53.5270010Z         let buffer = UnsafeMutableBufferPointer(start: &array, count: count)
2020-11-15T22:51:53.5271190Z                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:51:53.5273620Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/bits/Sources/Bits/Data+BytesConvertible.swift:6:56: note: implicit argument conversion from 'Bytes' (aka 'Array<UInt8>') to 'UnsafeMutablePointer<Byte>?' (aka 'Optional<UnsafeMutablePointer<UInt8>>') produces a pointer valid only for the duration of the call to 'init(start:count:)'
2020-11-15T22:51:53.5275500Z         let buffer = UnsafeMutableBufferPointer(start: &array, count: count)
2020-11-15T22:51:53.5276250Z                                                        ^~~~~~
2020-11-15T22:51:53.5278210Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/bits/Sources/Bits/Data+BytesConvertible.swift:6:56: note: use the 'withUnsafeMutableBufferPointer' method on Array in order to explicitly convert argument to buffer pointer valid for a defined scope
2020-11-15T22:51:53.5279950Z         let buffer = UnsafeMutableBufferPointer(start: &array, count: count)
2020-11-15T22:51:53.5281100Z                                                        ^
2020-11-15T22:51:53.5283180Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/bits/Sources/Bits/Data+BytesConvertible.swift:6:22: warning: initialization of 'UnsafeMutableBufferPointer<Byte>' (aka 'UnsafeMutableBufferPointer<UInt8>') results in a dangling buffer pointer
2020-11-15T22:51:53.5285330Z         let buffer = UnsafeMutableBufferPointer(start: &array, count: count)
2020-11-15T22:51:53.5286070Z                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:51:53.5288250Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/bits/Sources/Bits/Data+BytesConvertible.swift:6:56: note: implicit argument conversion from 'Bytes' (aka 'Array<UInt8>') to 'UnsafeMutablePointer<Byte>?' (aka 'Optional<UnsafeMutablePointer<UInt8>>') produces a pointer valid only for the duration of the call to 'init(start:count:)'
2020-11-15T22:51:53.5290130Z         let buffer = UnsafeMutableBufferPointer(start: &array, count: count)
2020-11-15T22:51:53.5290870Z                                                        ^~~~~~
2020-11-15T22:51:53.5293000Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/bits/Sources/Bits/Data+BytesConvertible.swift:6:56: note: use the 'withUnsafeMutableBufferPointer' method on Array in order to explicitly convert argument to buffer pointer valid for a defined scope
2020-11-15T22:51:53.5294830Z         let buffer = UnsafeMutableBufferPointer(start: &array, count: count)
2020-11-15T22:51:53.5295570Z                                                        ^
2020-11-15T22:51:53.5297580Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/bits/Sources/Bits/Data+BytesConvertible.swift:6:22: warning: initialization of 'UnsafeMutableBufferPointer<Byte>' (aka 'UnsafeMutableBufferPointer<UInt8>') results in a dangling buffer pointer
2020-11-15T22:51:53.5299750Z         let buffer = UnsafeMutableBufferPointer(start: &array, count: count)
2020-11-15T22:51:53.5300510Z                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:51:53.5303460Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/bits/Sources/Bits/Data+BytesConvertible.swift:6:56: note: implicit argument conversion from 'Bytes' (aka 'Array<UInt8>') to 'UnsafeMutablePointer<Byte>?' (aka 'Optional<UnsafeMutablePointer<UInt8>>') produces a pointer valid only for the duration of the call to 'init(start:count:)'
2020-11-15T22:51:53.5305670Z         let buffer = UnsafeMutableBufferPointer(start: &array, count: count)
2020-11-15T22:51:53.5306420Z                                                        ^~~~~~
2020-11-15T22:51:53.5308400Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/bits/Sources/Bits/Data+BytesConvertible.swift:6:56: note: use the 'withUnsafeMutableBufferPointer' method on Array in order to explicitly convert argument to buffer pointer valid for a defined scope
2020-11-15T22:51:53.5310490Z         let buffer = UnsafeMutableBufferPointer(start: &array, count: count)
2020-11-15T22:51:53.5311240Z                                                        ^
2020-11-15T22:51:53.5313870Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/bits/Sources/Bits/Data+BytesConvertible.swift:6:22: warning: initialization of 'UnsafeMutableBufferPointer<Byte>' (aka 'UnsafeMutableBufferPointer<UInt8>') results in a dangling buffer pointer
2020-11-15T22:51:53.5315690Z         let buffer = UnsafeMutableBufferPointer(start: &array, count: count)
2020-11-15T22:51:53.5316430Z                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:51:53.5318600Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/bits/Sources/Bits/Data+BytesConvertible.swift:6:56: note: implicit argument conversion from 'Bytes' (aka 'Array<UInt8>') to 'UnsafeMutablePointer<Byte>?' (aka 'Optional<UnsafeMutablePointer<UInt8>>') produces a pointer valid only for the duration of the call to 'init(start:count:)'
2020-11-15T22:51:53.5320480Z         let buffer = UnsafeMutableBufferPointer(start: &array, count: count)
2020-11-15T22:51:53.5321220Z                                                        ^~~~~~
2020-11-15T22:51:53.5323420Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/bits/Sources/Bits/Data+BytesConvertible.swift:6:56: note: use the 'withUnsafeMutableBufferPointer' method on Array in order to explicitly convert argument to buffer pointer valid for a defined scope
2020-11-15T22:51:53.5325160Z         let buffer = UnsafeMutableBufferPointer(start: &array, count: count)
2020-11-15T22:51:53.5325900Z                                                        ^
2020-11-15T22:51:54.0149370Z [204/223] Compiling FoundationPrelude URLRequest.swift
2020-11-15T22:51:54.1805390Z [205/224] Merging module FoundationPrelude
2020-11-15T22:51:54.5330580Z [206/229] Compiling Styleguide Styleguide.swift
2020-11-15T22:51:54.6167080Z [207/229] Compiling Styleguide TODO.swift
2020-11-15T22:51:55.4137340Z [212/229] Compiling Styleguide Components.swift
2020-11-15T22:51:55.4237810Z [213/229] Compiling Styleguide Normalize.swift
2020-11-15T22:51:55.4239310Z [216/229] Compiling Styleguide PointFreeBaseStyles.swift
2020-11-15T22:51:55.8203760Z [225/231] Merging module Bits
2020-11-15T22:51:55.9062000Z [226/232] Merging module Styleguide
2020-11-15T22:51:56.9444500Z [227/234] Compiling c-nioatomics.c
2020-11-15T22:51:57.2228120Z [228/244] Compiling PointFreePrelude Concat.swift
2020-11-15T22:51:57.2757080Z [229/244] Compiling PointFreePrelude Zip.swift
2020-11-15T22:51:57.2809700Z [230/244] Compiling PointFreePrelude Zurry.swift
2020-11-15T22:51:57.6583320Z [232/244] Compiling PointFreePrelude Dispatch.swift
2020-11-15T22:51:57.6584430Z [233/244] Compiling PointFreePrelude Either.swift
2020-11-15T22:51:57.6848820Z [234/244] Compiling PointFreePrelude URLRequest.swift
2020-11-15T22:51:57.6850210Z [235/244] Compiling PointFreePrelude Update.swift
2020-11-15T22:51:58.0831180Z [236/244] Compiling PointFreePrelude FileLineLogging.swift
2020-11-15T22:51:58.0842200Z [237/244] Compiling PointFreePrelude Parallel.swift
2020-11-15T22:51:58.0843120Z [238/244] Compiling PointFreePrelude Tuple.swift
2020-11-15T22:51:58.2631330Z [239/245] Merging module PointFreePrelude
2020-11-15T22:51:58.8407010Z [240/247] Compiling GitHub Client.swift
2020-11-15T22:51:58.9463460Z [241/247] Compiling GitHub Model.swift
2020-11-15T22:51:59.1887030Z [242/248] Merging module GitHub
2020-11-15T22:51:59.5556860Z [244/250] Compiling CssReset Reset.swift
2020-11-15T22:51:59.7146390Z [245/251] Merging module CssReset
2020-11-15T22:51:59.7785470Z [246/252] Merging module Stripe
2020-11-15T22:51:59.9892380Z [247/253] Compiling StripeTestSupport Mocks.swift
2020-11-15T22:52:00.0541650Z [248/254] Compiling c-atomics.c
2020-11-15T22:52:00.1782490Z [249/314] Merging module GitHubTestSupport
2020-11-15T22:52:00.7228930Z [250/349] Compiling NIOConcurrencyHelpers NIOAtomic.swift
2020-11-15T22:52:00.9722400Z [251/350] Merging module StripeTestSupport
2020-11-15T22:52:01.2914010Z [252/351] Compiling StripeTests StripeTests.swift
2020-11-15T22:52:01.4411970Z [253/351] Compiling NIOConcurrencyHelpers lock.swift
2020-11-15T22:52:01.7582190Z [254/351] Compiling NIOConcurrencyHelpers atomics.swift
2020-11-15T22:52:01.8594600Z [255/352] Merging module NIOConcurrencyHelpers
2020-11-15T22:52:01.9909000Z [256/353] Compiling Models BlogPost0023_OpenSourcingSnapshotTesting.swift
2020-11-15T22:52:02.0009360Z [257/353] Compiling Models BlogPost0024_holidayDiscount.swift
2020-11-15T22:52:02.0211360Z [258/353] Compiling Models BlogPost0025_yearInReview.swift
2020-11-15T22:52:02.0313030Z [259/353] Compiling Models BlogPost0026_html020.swift
2020-11-15T22:52:02.0414760Z [260/353] Compiling Models BlogPost0027_OpenSourcingGen.swift
2020-11-15T22:52:02.0480650Z [261/353] Compiling Models BlogPost0028_OpenSourcingEnumProperties.swift
2020-11-15T22:52:02.0482650Z [262/353] Compiling Models BlogPost0029_EnterpriseSubscriptions.swift
2020-11-15T22:52:02.0483730Z [263/353] Compiling Models BlogPost0030_SwiftUIAndStateManagementCorrections.swift
2020-11-15T22:52:02.0484820Z [264/353] Compiling Models BlogPost0031_HigherOrderSnapshotStrategies.swift
2020-11-15T22:52:02.0485690Z [265/353] Compiling Models BlogPost0032_AFreeOverviewOfCombine.swift
2020-11-15T22:52:02.0486370Z [266/353] Compiling Models BlogPost0033_CyberMonday2019.swift
2020-11-15T22:52:02.0486960Z [267/353] Compiling Models BlogPost0034_TestingSwiftUI.swift
2020-11-15T22:52:02.0487640Z [268/353] Compiling Models BlogPost0035_SnapshotTestingSwiftUI.swift
2020-11-15T22:52:02.0488330Z [269/353] Compiling Models BlogPost0036_HolidayDiscount.swift
2020-11-15T22:52:02.0488910Z [270/353] Compiling Models BlogPost0037_2019YearInReview.swift
2020-11-15T22:52:02.0489550Z [271/353] Compiling Models BlogPost0038_OpenSourcingCasePaths.swift
2020-11-15T22:52:02.0490260Z [272/353] Compiling Models BlogPost0039_AnnouncingReferrals.swift
2020-11-15T22:52:02.0490970Z [273/353] Compiling Models BlogPost0040_AnnouncingCollections.swift
2020-11-15T22:52:02.0491920Z [274/353] Compiling Models BlogPost0041_AnnouncingTheComposableArchitecture.swift
2020-11-15T22:52:02.0492830Z [275/353] Compiling Models BlogPost0042_RegionalDiscounts.swift
2020-11-15T22:52:02.0493680Z [276/353] Compiling Models BlogPost0043_AnnouncingComposableCoreLocation.swift
2020-11-15T22:52:02.0494470Z [277/353] Compiling Models BlogPost0044_Signposts.swift
2020-11-15T22:52:02.0495200Z [278/353] Compiling Models BlogPost0045_OpenSourcingCombineSchedulers.swift
2020-11-15T22:52:02.3060170Z [279/376] Compiling GitHubTests GitHubTests.swift
2020-11-15T22:52:02.6066850Z [280/377] Merging module CssTestSupport
2020-11-15T22:52:03.4180820Z [281/448] Compiling NIO AddressedEnvelope.swift
2020-11-15T22:52:03.4281320Z [282/448] Compiling NIO BSDSocketAPI.swift
2020-11-15T22:52:03.4382820Z [283/448] Compiling NIO BSDSocketAPIPosix.swift
2020-11-15T22:52:03.4483870Z [284/448] Compiling NIO BSDSocketAPIWindows.swift
2020-11-15T22:52:03.4489460Z [285/448] Compiling NIO BaseSocket.swift
2020-11-15T22:52:03.4591560Z [286/448] Compiling NIO BaseSocketChannel.swift
2020-11-15T22:52:03.4693070Z [287/448] Compiling NIO BaseStreamSocketChannel.swift
2020-11-15T22:52:03.4794540Z [288/448] Compiling NIO Bootstrap.swift
2020-11-15T22:52:03.4896600Z [289/448] Compiling NIO ByteBuffer-aux.swift
2020-11-15T22:52:03.4999500Z [290/448] Compiling NIO ByteBuffer-conversions.swift
2020-11-15T22:52:03.5102600Z [291/448] Compiling NIO ByteBuffer-core.swift
2020-11-15T22:52:03.5204750Z [292/448] Compiling NIO ByteBuffer-int.swift
2020-11-15T22:52:03.5307040Z [293/448] Compiling NIO ByteBuffer-views.swift
2020-11-15T22:52:03.5408600Z [294/448] Compiling NIO Channel.swift
2020-11-15T22:52:03.5510080Z [295/448] Compiling NIO ChannelHandler.swift
2020-11-15T22:52:03.5611610Z [296/448] Compiling NIO ChannelHandlers.swift
2020-11-15T22:52:03.5713060Z [297/448] Compiling NIO ChannelInvoker.swift
2020-11-15T22:52:03.5814570Z [298/448] Compiling NIO ChannelOption.swift
2020-11-15T22:52:03.5916130Z [299/448] Compiling NIO ChannelPipeline.swift
2020-11-15T22:52:03.6018460Z [300/448] Compiling NIO CircularBuffer.swift
2020-11-15T22:52:03.6119920Z [301/448] Compiling NIO Codec.swift
2020-11-15T22:52:03.6276090Z [302/448] Compiling NIO ControlMessage.swift
2020-11-15T22:52:03.6378230Z [303/448] Compiling NIO ConvenienceOptionSupport.swift
2020-11-15T22:52:05.1765730Z [304/471] Compiling NIO UniversalBootstrapSupport.swift
2020-11-15T22:52:05.1866310Z [305/471] Compiling NIO Utilities.swift
2020-11-15T22:52:05.1968460Z [306/471] Compiling Models 0006-Setters.swift
2020-11-15T22:52:05.2068750Z [307/471] Compiling Models 0007-SettersAndKeyPaths.swift
2020-11-15T22:52:05.2171200Z [308/471] Compiling Models 0008-GettersAndKeyPaths.swift
2020-11-15T22:52:05.2271400Z [309/471] Compiling Models 0009-AlgebraicDataTypesPt2.swift
2020-11-15T22:52:05.2374130Z [310/471] Compiling Models 0010-ATaleOfTwoFlatMaps.swift
2020-11-15T22:52:05.2477310Z [311/471] Compiling Models 0011-CompositionWithoutOperators.swift
2020-11-15T22:52:05.2578250Z [312/471] Compiling Models 0012-Tagged.swift
2020-11-15T22:52:05.2680060Z [313/471] Compiling Models 0013-Map.swift
2020-11-15T22:52:05.2756610Z [314/471] Compiling Models 0014-Contravariance.swift
2020-11-15T22:52:05.2858820Z [315/471] Compiling Models 0015-SettersPt3.swift
2020-11-15T22:52:05.2961090Z [316/471] Compiling Models 0016-DependencyInjection.swift
2020-11-15T22:52:05.3064140Z [317/471] Compiling Models 0017-StylingWithFunctionsPt2.swift
2020-11-15T22:52:05.3166640Z [318/471] Compiling Models 0018-EnvironmentPt2.swift
2020-11-15T22:52:05.3268950Z [319/471] Compiling Models 0019-ADT-Pt3.swift
2020-11-15T22:52:05.3371330Z [320/471] Compiling Models 0020-NonEmpty.swift
2020-11-15T22:52:05.3473990Z [321/471] Compiling Models 0021-PlaygroundDrivenDevelopment.swift
2020-11-15T22:52:05.3576610Z [322/471] Compiling Models 0022-ATourOfPointFreeCo.swift
2020-11-15T22:52:05.3679090Z [323/471] Compiling Models 0023-Zip-pt1.swift
2020-11-15T22:52:05.3782270Z [324/471] Compiling Models 0024-Zip-pt2.swift
2020-11-15T22:52:05.3883590Z [325/471] Compiling Models 0025-Zip-pt3.swift
2020-11-15T22:52:05.3985510Z [326/471] Compiling Models 0026-DSL-pt1.swift
2020-11-15T22:52:06.6731510Z [327/494] Compiling Models 0027-DSL-pt2.swift
2020-11-15T22:52:06.6833630Z [328/494] Compiling Models 0028-HTML-DSL.swift
2020-11-15T22:52:06.6936020Z [329/494] Compiling Models 0029-DSL-vs-TemplatingLanguages.swift
2020-11-15T22:52:06.7038410Z [330/494] Compiling Models 0030-Randomness.swift
2020-11-15T22:52:06.7140620Z [331/494] Compiling Models 0031-ArbitraryPt1.swift
2020-11-15T22:52:06.7242950Z [332/494] Compiling Models 0032-ArbitraryPt2.swift
2020-11-15T22:52:06.7345290Z [333/494] Compiling Models 0033-ProtocolWitnessesPt1.swift
2020-11-15T22:52:06.7447860Z [334/494] Compiling Models 0034-ProtocolWitnessesPt2.swift
2020-11-15T22:52:06.7550670Z [335/494] Compiling Models 0035-AdvancedProtocolWitnessesPt1.swift
2020-11-15T22:52:06.7651610Z [336/494] Compiling Models 0036-AdvancedProtocolWitnessesPt2.swift
2020-11-15T22:52:06.7753840Z [337/494] Compiling Models 0037-ProtocolOrientedLibraryDesignPt1.swift
2020-11-15T22:52:06.7790520Z [338/494] Compiling Models 0038-ProtocolOrientedLibraryDesignPt2.swift
2020-11-15T22:52:06.7893090Z [339/494] Compiling Models 0039-WitnessOrientedLibraryDesign.swift
2020-11-15T22:52:06.7995580Z [340/494] Compiling Models 0040-AsyncSnapshot.swift
2020-11-15T22:52:06.8098430Z [341/494] Compiling Models 0041-TourOfSnapshotTesting.swift
2020-11-15T22:52:06.8157010Z [342/494] Compiling Models 0042-TheManyFacesOfFlatMapPt1.swift
2020-11-15T22:52:06.8259560Z [343/494] Compiling Models 0043-TheManyFacesOfFlatMapPt2.swift
2020-11-15T22:52:06.8332980Z [344/494] Compiling Models 0044-TheManyFacesOfFlatMapPt3.swift
2020-11-15T22:52:06.8435660Z [345/494] Compiling Models 0045-TheManyFacesOfFlatMapPt4.swift
2020-11-15T22:52:06.8464210Z [346/494] Compiling Models 0046-TheManyFacesOfFlatMapPt5.swift
2020-11-15T22:52:06.8566640Z [347/494] Compiling Models 0047-PredictableRandomnessPt1.swift
2020-11-15T22:52:06.8669440Z [348/494] Compiling Models 0048-PredictableRandomnessPt2.swift
2020-11-15T22:52:06.8762800Z [349/494] Compiling Models 0049-GenerativeArtPt1.swift
2020-11-15T22:52:08.8474060Z [350/517] Compiling Models 0050-GenerativeArtPt2.swift
2020-11-15T22:52:08.8574330Z [351/517] Compiling Models 0051-StructsVsEnums.swift
2020-11-15T22:52:08.8615500Z [352/517] Compiling Models 0052-EnumProperties.swift
2020-11-15T22:52:08.8717860Z [353/517] Compiling Models 0053-SwiftSyntaxEnumProperties.swift
2020-11-15T22:52:08.8820510Z [354/517] Compiling Models 0054-AdvancedSwiftSyntaxEnumProperties.swift
2020-11-15T22:52:08.8923140Z [355/517] Compiling Models 0055-SwiftSyntaxCommandLineTool.swift
2020-11-15T22:52:08.9023190Z [356/517] Compiling Models 0056-WhatIsAParserPt1.swift
2020-11-15T22:52:08.9125440Z [357/517] Compiling Models 0057-WhatIsAParserPt2.swift
2020-11-15T22:52:08.9226120Z [358/517] Compiling Models 0058-WhatIsAParserPt3.swift
2020-11-15T22:52:08.9328250Z [359/517] Compiling Models 0059-ComposableParsingMap.swift
2020-11-15T22:52:08.9428990Z [360/517] Compiling Models 0060-ComposableParsingFlatMap.swift
2020-11-15T22:52:08.9531070Z [361/517] Compiling Models 0061-ComposableParsingZip.swift
2020-11-15T22:52:08.9631690Z [362/517] Compiling Models 0062-ParserCombinatorsPt1.swift
2020-11-15T22:52:08.9729540Z [363/517] Compiling Models 0063-ParserCombinatorsPt2.swift
2020-11-15T22:52:08.9832210Z [364/517] Compiling Models 0064-ParserCombinatorsPt3.swift
2020-11-15T22:52:08.9934900Z [365/517] Compiling Models 0065-SwiftUIAndStateManagementPt1.swift
2020-11-15T22:52:09.0036960Z [366/517] Compiling Models 0066-SwiftUIAndStateManagementPt2.swift
2020-11-15T22:52:09.0054930Z [367/517] Compiling Models 0067-SwiftUIAndStateManagementPt3.swift
2020-11-15T22:52:09.0157880Z [368/517] Compiling Models 0068-ComposableStateManagementReducers.swift
2020-11-15T22:52:09.0224080Z [369/517] Compiling Models 0069-ComposableStateManagementStatePullbacks.swift
2020-11-15T22:52:09.0287030Z [370/517] Compiling Models 0070-ComposableStateManagementActionPullbacks.swift
2020-11-15T22:52:09.0390000Z [371/517] Compiling Models 0071-ComposableStateManagementHigherOrderReducers.swift
2020-11-15T22:52:09.0492760Z [372/517] Compiling Models 0072-ModularStateManagementReducers.swift
2020-11-15T22:52:09.1329780Z [373/539] Compiling NIO IOData.swift
2020-11-15T22:52:09.1330950Z [374/539] Compiling NIO IntegerTypes.swift
2020-11-15T22:52:09.1331780Z [375/539] Compiling NIO Interfaces.swift
2020-11-15T22:52:09.1332710Z [376/539] Compiling NIO Linux.swift
2020-11-15T22:52:09.1333460Z [377/539] Compiling NIO LinuxCPUSet.swift
2020-11-15T22:52:09.1334330Z [378/539] Compiling NIO MarkedCircularBuffer.swift
2020-11-15T22:52:09.1335250Z [379/539] Compiling NIO MulticastChannel.swift
2020-11-15T22:52:09.1336030Z [380/539] Compiling NIO NIOAny.swift
2020-11-15T22:52:09.1336880Z [381/539] Compiling NIO NIOCloseOnErrorHandler.swift
2020-11-15T22:52:09.1338060Z [382/539] Compiling NIO NIOThreadPool.swift
2020-11-15T22:52:09.1338930Z [383/539] Compiling NIO NonBlockingFileIO.swift
2020-11-15T22:52:09.1339980Z [384/539] Compiling NIO PendingDatagramWritesManager.swift
2020-11-15T22:52:09.1341060Z [385/539] Compiling NIO PendingWritesManager.swift
2020-11-15T22:52:09.1341920Z [386/539] Compiling NIO PipeChannel.swift
2020-11-15T22:52:09.1342660Z [387/539] Compiling NIO PipePair.swift
2020-11-15T22:52:09.1343810Z [388/539] Compiling NIO PriorityQueue.swift
2020-11-15T22:52:09.1344830Z [389/539] Compiling NIO RecvByteBufferAllocator.swift
2020-11-15T22:52:09.1345710Z [390/539] Compiling NIO Resolver.swift
2020-11-15T22:52:09.9104260Z [392/540] Merging module GitHubTests
2020-11-15T22:52:10.4541770Z [394/542] Merging module StripeTests
2020-11-15T22:52:11.0620070Z [395/543] Compiling FunctionalCssTests FunctionalCssTests.swift
2020-11-15T22:52:11.2555780Z [396/544] Compiling Models 0073-ModularStateManagementViewState.swift
2020-11-15T22:52:11.2599580Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0073-ModularStateManagementViewState.swift:4:54: warning: expression took 247ms to type-check (limit: 200ms)
2020-11-15T22:52:11.2669480Z   static let ep73_modularStateManagement_viewState = Episode(
2020-11-15T22:52:11.2771040Z                                                      ^~~~~~~~
2020-11-15T22:52:11.2873540Z [397/544] Compiling Models 0074-ModularStateManagementViewActions.swift
2020-11-15T22:52:11.2976890Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0073-ModularStateManagementViewState.swift:4:54: warning: expression took 247ms to type-check (limit: 200ms)
2020-11-15T22:52:11.3079450Z   static let ep73_modularStateManagement_viewState = Episode(
2020-11-15T22:52:11.3178530Z                                                      ^~~~~~~~
2020-11-15T22:52:11.3239190Z [398/544] Compiling Models 0075-ModularStateManagementWhatsThePoint.swift
2020-11-15T22:52:11.3342370Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0073-ModularStateManagementViewState.swift:4:54: warning: expression took 247ms to type-check (limit: 200ms)
2020-11-15T22:52:11.3443540Z   static let ep73_modularStateManagement_viewState = Episode(
2020-11-15T22:52:11.3545060Z                                                      ^~~~~~~~
2020-11-15T22:52:11.3651840Z [399/544] Compiling Models 0076-EffectfulStateManagementSynchronousEffects.swift
2020-11-15T22:52:11.3730090Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0073-ModularStateManagementViewState.swift:4:54: warning: expression took 247ms to type-check (limit: 200ms)
2020-11-15T22:52:11.3815130Z   static let ep73_modularStateManagement_viewState = Episode(
2020-11-15T22:52:11.3955070Z                                                      ^~~~~~~~
2020-11-15T22:52:11.4057910Z [400/544] Compiling Models 0077-EffectfulStateManagementUnidirectionalEffects.swift
2020-11-15T22:52:11.4162460Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0073-ModularStateManagementViewState.swift:4:54: warning: expression took 247ms to type-check (limit: 200ms)
2020-11-15T22:52:11.4262440Z   static let ep73_modularStateManagement_viewState = Episode(
2020-11-15T22:52:11.4364540Z                                                      ^~~~~~~~
2020-11-15T22:52:11.4436470Z [401/544] Compiling Models 0078-EffectfulStateManagementAsynchronousEffects.swift
2020-11-15T22:52:11.4540120Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0073-ModularStateManagementViewState.swift:4:54: warning: expression took 247ms to type-check (limit: 200ms)
2020-11-15T22:52:11.4639070Z   static let ep73_modularStateManagement_viewState = Episode(
2020-11-15T22:52:11.4672900Z                                                      ^~~~~~~~
2020-11-15T22:52:11.4775310Z [402/544] Compiling Models 0079-EffectfulStateManagementThePoint.swift
2020-11-15T22:52:11.4878880Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0073-ModularStateManagementViewState.swift:4:54: warning: expression took 247ms to type-check (limit: 200ms)
2020-11-15T22:52:11.4946400Z   static let ep73_modularStateManagement_viewState = Episode(
2020-11-15T22:52:11.5055310Z                                                      ^~~~~~~~
2020-11-15T22:52:11.5157400Z [403/544] Compiling Models 0080-CombineAndEffectsPt1.swift
2020-11-15T22:52:11.5260900Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0073-ModularStateManagementViewState.swift:4:54: warning: expression took 247ms to type-check (limit: 200ms)
2020-11-15T22:52:11.5362960Z   static let ep73_modularStateManagement_viewState = Episode(
2020-11-15T22:52:11.5464370Z                                                      ^~~~~~~~
2020-11-15T22:52:11.5566540Z [404/544] Compiling Models 0081-CombineAndEffectsPt2.swift
2020-11-15T22:52:11.5669430Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0073-ModularStateManagementViewState.swift:4:54: warning: expression took 247ms to type-check (limit: 200ms)
2020-11-15T22:52:11.5771590Z   static let ep73_modularStateManagement_viewState = Episode(
2020-11-15T22:52:11.5873100Z                                                      ^~~~~~~~
2020-11-15T22:52:11.5975790Z [405/544] Compiling Models 0082-TestableStateManagementReducers.swift
2020-11-15T22:52:11.6079070Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0073-ModularStateManagementViewState.swift:4:54: warning: expression took 247ms to type-check (limit: 200ms)
2020-11-15T22:52:11.6085870Z   static let ep73_modularStateManagement_viewState = Episode(
2020-11-15T22:52:11.6187010Z                                                      ^~~~~~~~
2020-11-15T22:52:11.6287930Z [406/544] Compiling Models 0083-TestableStateManagementEffects.swift
2020-11-15T22:52:11.6391200Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0073-ModularStateManagementViewState.swift:4:54: warning: expression took 247ms to type-check (limit: 200ms)
2020-11-15T22:52:11.6490300Z   static let ep73_modularStateManagement_viewState = Episode(
2020-11-15T22:52:11.6494100Z                                                      ^~~~~~~~
2020-11-15T22:52:11.6596310Z [407/544] Compiling Models 0084-TestableStateManagementErgonomics.swift
2020-11-15T22:52:11.6699410Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0073-ModularStateManagementViewState.swift:4:54: warning: expression took 247ms to type-check (limit: 200ms)
2020-11-15T22:52:11.6801590Z   static let ep73_modularStateManagement_viewState = Episode(
2020-11-15T22:52:11.6896980Z                                                      ^~~~~~~~
2020-11-15T22:52:11.6999620Z [408/544] Compiling Models 0085-TestableStateManagementSnapshotThePoint.swift
2020-11-15T22:52:11.7105330Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0073-ModularStateManagementViewState.swift:4:54: warning: expression took 247ms to type-check (limit: 200ms)
2020-11-15T22:52:11.7204770Z   static let ep73_modularStateManagement_viewState = Episode(
2020-11-15T22:52:11.7271340Z                                                      ^~~~~~~~
2020-11-15T22:52:11.7373500Z [409/544] Compiling Models 0086-SwiftUISnapshotTesting.swift
2020-11-15T22:52:11.7476710Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0073-ModularStateManagementViewState.swift:4:54: warning: expression took 247ms to type-check (limit: 200ms)
2020-11-15T22:52:11.7578940Z   static let ep73_modularStateManagement_viewState = Episode(
2020-11-15T22:52:11.7808970Z                                                      ^~~~~~~~
2020-11-15T22:52:11.7943580Z [410/544] Compiling Models 0087-TheCaseForCasePathsPt1.swift
2020-11-15T22:52:11.7947270Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0073-ModularStateManagementViewState.swift:4:54: warning: expression took 247ms to type-check (limit: 200ms)
2020-11-15T22:52:11.8143380Z   static let ep73_modularStateManagement_viewState = Episode(
2020-11-15T22:52:11.8144110Z                                                      ^~~~~~~~
2020-11-15T22:52:11.8345340Z [411/544] Compiling Models 0088-TheCaseForCasePathsPt2.swift
2020-11-15T22:52:11.8447630Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0073-ModularStateManagementViewState.swift:4:54: warning: expression took 247ms to type-check (limit: 200ms)
2020-11-15T22:52:11.8484020Z   static let ep73_modularStateManagement_viewState = Episode(
2020-11-15T22:52:11.8549560Z                                                      ^~~~~~~~
2020-11-15T22:52:11.8640010Z [412/544] Compiling Models 0089-TheCaseForCasePathsPt3.swift
2020-11-15T22:52:11.8743120Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0073-ModularStateManagementViewState.swift:4:54: warning: expression took 247ms to type-check (limit: 200ms)
2020-11-15T22:52:11.8842950Z   static let ep73_modularStateManagement_viewState = Episode(
2020-11-15T22:52:11.8944430Z                                                      ^~~~~~~~
2020-11-15T22:52:11.9047080Z [413/544] Compiling Models 0090-ComposingArchitectureWithCasePaths.swift
2020-11-15T22:52:11.9067680Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0073-ModularStateManagementViewState.swift:4:54: warning: expression took 247ms to type-check (limit: 200ms)
2020-11-15T22:52:11.9151930Z   static let ep73_modularStateManagement_viewState = Episode(
2020-11-15T22:52:11.9253350Z                                                      ^~~~~~~~
2020-11-15T22:52:11.9355670Z [414/544] Compiling Models 0091-ModularDependencyInjectionPt1.swift
2020-11-15T22:52:11.9445400Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0073-ModularStateManagementViewState.swift:4:54: warning: expression took 247ms to type-check (limit: 200ms)
2020-11-15T22:52:11.9547630Z   static let ep73_modularStateManagement_viewState = Episode(
2020-11-15T22:52:11.9649210Z                                                      ^~~~~~~~
2020-11-15T22:52:11.9681390Z [415/544] Compiling Models 0092-ModularDependencyInjectionPt2.swift
2020-11-15T22:52:11.9775450Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0073-ModularStateManagementViewState.swift:4:54: warning: expression took 247ms to type-check (limit: 200ms)
2020-11-15T22:52:11.9877570Z   static let ep73_modularStateManagement_viewState = Episode(
2020-11-15T22:52:11.9958180Z                                                      ^~~~~~~~
2020-11-15T22:52:12.0061290Z [416/544] Compiling Models 0093-ModularDependencyInjectionPt3.swift
2020-11-15T22:52:12.0164570Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0073-ModularStateManagementViewState.swift:4:54: warning: expression took 247ms to type-check (limit: 200ms)
2020-11-15T22:52:12.0266740Z   static let ep73_modularStateManagement_viewState = Episode(
2020-11-15T22:52:12.0368220Z                                                      ^~~~~~~~
2020-11-15T22:52:12.0470660Z [417/544] Compiling Models 0094-AdaptiveStateManagementPt1.swift
2020-11-15T22:52:12.0573910Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0073-ModularStateManagementViewState.swift:4:54: warning: expression took 247ms to type-check (limit: 200ms)
2020-11-15T22:52:12.0676300Z   static let ep73_modularStateManagement_viewState = Episode(
2020-11-15T22:52:12.0708390Z                                                      ^~~~~~~~
2020-11-15T22:52:12.0778930Z [418/544] Compiling Models 0095-AdaptiveStateManagementPt2.swift
2020-11-15T22:52:12.0882140Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0073-ModularStateManagementViewState.swift:4:54: warning: expression took 247ms to type-check (limit: 200ms)
2020-11-15T22:52:12.0968160Z   static let ep73_modularStateManagement_viewState = Episode(
2020-11-15T22:52:12.0983750Z                                                      ^~~~~~~~
2020-11-15T22:52:12.1077090Z [419/544] Compiling NIO Selectable.swift
2020-11-15T22:52:12.1096190Z [420/544] Compiling NIO SelectableEventLoop.swift
2020-11-15T22:52:12.1203950Z [421/544] Compiling NIO Selector.swift
2020-11-15T22:52:12.1384370Z [422/544] Compiling NIO ServerSocket.swift
2020-11-15T22:52:12.1470820Z [423/544] Compiling NIO SingleStepByteToMessageDecoder.swift
2020-11-15T22:52:12.1518040Z [424/544] Compiling NIO Socket.swift
2020-11-15T22:52:12.1619500Z [425/544] Compiling NIO SocketAddresses.swift
2020-11-15T22:52:12.1721060Z [426/544] Compiling NIO SocketChannel.swift
2020-11-15T22:52:12.1822740Z [427/544] Compiling NIO SocketOptionProvider.swift
2020-11-15T22:52:12.1917420Z [428/544] Compiling NIO SocketProtocols.swift
2020-11-15T22:52:12.2018830Z [429/544] Compiling NIO System.swift
2020-11-15T22:52:12.2120160Z [430/544] Compiling NIO Thread.swift
2020-11-15T22:52:12.2220950Z [431/544] Compiling NIO ThreadPosix.swift
2020-11-15T22:52:12.2288900Z [432/544] Compiling NIO ThreadWindows.swift
2020-11-15T22:52:12.2348290Z [433/544] Compiling NIO TypeAssistedChannelHandler.swift
2020-11-15T22:52:12.2399470Z [436/544] Merging module FunctionalCssTests
2020-11-15T22:52:12.2472200Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/MapZipFlatMap.swift:2:37: warning: expression took 469ms to type-check (limit: 200ms)
2020-11-15T22:52:12.2513540Z   public static let mapZipFlatMap = Self(
2020-11-15T22:52:12.2574950Z                                     ^~~~~
2020-11-15T22:52:12.2658330Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Randomness.swift:2:34: warning: expression took 584ms to type-check (limit: 200ms)
2020-11-15T22:52:12.2757910Z   public static let randomness = Self(
2020-11-15T22:52:12.2775290Z                                  ^~~~~
2020-11-15T22:52:12.2830880Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Combine.swift:2:31: warning: expression took 208ms to type-check (limit: 200ms)
2020-11-15T22:52:12.2859930Z   public static let combine = Self(
2020-11-15T22:52:12.2936540Z                               ^~~~~
2020-11-15T22:52:12.2953990Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/ComposableArchitecture.swift:2:46: warning: expression took 794ms to type-check (limit: 200ms)
2020-11-15T22:52:12.2960900Z   public static let composableArchitecture = Self(
2020-11-15T22:52:12.3007090Z                                              ^~~~~
2020-11-15T22:52:12.3099890Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Dependencies.swift:2:36: warning: expression took 939ms to type-check (limit: 200ms)
2020-11-15T22:52:12.3201570Z   public static let dependencies = Self(
2020-11-15T22:52:12.3212220Z                                    ^~~~~
2020-11-15T22:52:12.3246370Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/AllCollections.swift:2:35: warning: expression took 2090ms to type-check (limit: 200ms)
2020-11-15T22:52:12.3347060Z   public static let all: [Self] = [
2020-11-15T22:52:12.3353810Z                                   ^
2020-11-15T22:52:12.3363810Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:3:5: warning: expression took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.3402110Z     Self(
2020-11-15T22:52:12.3454550Z     ^~~~~
2020-11-15T22:52:12.3458280Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:2:35: warning: getter 'parsing' took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.3459420Z   public static var parsing: Self {
2020-11-15T22:52:12.3460010Z                                   ^
2020-11-15T22:52:12.3461470Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/MapZipFlatMap.swift:2:37: warning: expression took 469ms to type-check (limit: 200ms)
2020-11-15T22:52:12.3462630Z   public static let mapZipFlatMap = Self(
2020-11-15T22:52:12.3463250Z                                     ^~~~~
2020-11-15T22:52:12.3464660Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Randomness.swift:2:34: warning: expression took 584ms to type-check (limit: 200ms)
2020-11-15T22:52:12.3475290Z   public static let randomness = Self(
2020-11-15T22:52:12.3541360Z                                  ^~~~~
2020-11-15T22:52:12.3551950Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Combine.swift:2:31: warning: expression took 208ms to type-check (limit: 200ms)
2020-11-15T22:52:12.3578850Z   public static let combine = Self(
2020-11-15T22:52:12.3679340Z                               ^~~~~
2020-11-15T22:52:12.3728500Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/ComposableArchitecture.swift:2:46: warning: expression took 794ms to type-check (limit: 200ms)
2020-11-15T22:52:12.3760050Z   public static let composableArchitecture = Self(
2020-11-15T22:52:12.3860440Z                                              ^~~~~
2020-11-15T22:52:12.3963310Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Dependencies.swift:2:36: warning: expression took 939ms to type-check (limit: 200ms)
2020-11-15T22:52:12.4061950Z   public static let dependencies = Self(
2020-11-15T22:52:12.4162180Z                                    ^~~~~
2020-11-15T22:52:12.4264600Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/AllCollections.swift:2:35: warning: expression took 2090ms to type-check (limit: 200ms)
2020-11-15T22:52:12.4364180Z   public static let all: [Self] = [
2020-11-15T22:52:12.4388220Z                                   ^
2020-11-15T22:52:12.4490720Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:3:5: warning: expression took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.4589530Z     Self(
2020-11-15T22:52:12.4720300Z     ^~~~~
2020-11-15T22:52:12.4751130Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:2:35: warning: getter 'parsing' took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.4852780Z   public static var parsing: Self {
2020-11-15T22:52:12.4954060Z                                   ^
2020-11-15T22:52:12.5063010Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/MapZipFlatMap.swift:2:37: warning: expression took 469ms to type-check (limit: 200ms)
2020-11-15T22:52:12.5164900Z   public static let mapZipFlatMap = Self(
2020-11-15T22:52:12.5314430Z                                     ^~~~~
2020-11-15T22:52:12.5417080Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Randomness.swift:2:34: warning: expression took 584ms to type-check (limit: 200ms)
2020-11-15T22:52:12.5518900Z   public static let randomness = Self(
2020-11-15T22:52:12.5564350Z                                  ^~~~~
2020-11-15T22:52:12.5666970Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Combine.swift:2:31: warning: expression took 208ms to type-check (limit: 200ms)
2020-11-15T22:52:12.5691810Z   public static let combine = Self(
2020-11-15T22:52:12.5771590Z                               ^~~~~
2020-11-15T22:52:12.5871690Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/ComposableArchitecture.swift:2:46: warning: expression took 794ms to type-check (limit: 200ms)
2020-11-15T22:52:12.5953070Z   public static let composableArchitecture = Self(
2020-11-15T22:52:12.6054480Z                                              ^~~~~
2020-11-15T22:52:12.6157230Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Dependencies.swift:2:36: warning: expression took 939ms to type-check (limit: 200ms)
2020-11-15T22:52:12.6191010Z   public static let dependencies = Self(
2020-11-15T22:52:12.6292240Z                                    ^~~~~
2020-11-15T22:52:12.6411940Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/AllCollections.swift:2:35: warning: expression took 2090ms to type-check (limit: 200ms)
2020-11-15T22:52:12.6513710Z   public static let all: [Self] = [
2020-11-15T22:52:12.6599770Z                                   ^
2020-11-15T22:52:12.6702300Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:3:5: warning: expression took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.6823650Z     Self(
2020-11-15T22:52:12.6924970Z     ^~~~~
2020-11-15T22:52:12.6960560Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:2:35: warning: getter 'parsing' took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.7062280Z   public static var parsing: Self {
2020-11-15T22:52:12.7179650Z                                   ^
2020-11-15T22:52:12.7250840Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/MapZipFlatMap.swift:2:37: warning: expression took 469ms to type-check (limit: 200ms)
2020-11-15T22:52:12.7330550Z   public static let mapZipFlatMap = Self(
2020-11-15T22:52:12.7455050Z                                     ^~~~~
2020-11-15T22:52:12.7557690Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Randomness.swift:2:34: warning: expression took 584ms to type-check (limit: 200ms)
2020-11-15T22:52:12.7627620Z   public static let randomness = Self(
2020-11-15T22:52:12.7735980Z                                  ^~~~~
2020-11-15T22:52:12.7780870Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Combine.swift:2:31: warning: expression took 208ms to type-check (limit: 200ms)
2020-11-15T22:52:12.7848640Z   public static let combine = Self(
2020-11-15T22:52:12.7948390Z                               ^~~~~
2020-11-15T22:52:12.8036130Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/ComposableArchitecture.swift:2:46: warning: expression took 794ms to type-check (limit: 200ms)
2020-11-15T22:52:12.8088040Z   public static let composableArchitecture = Self(
2020-11-15T22:52:12.8108440Z                                              ^~~~~
2020-11-15T22:52:12.8110170Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Dependencies.swift:2:36: warning: expression took 939ms to type-check (limit: 200ms)
2020-11-15T22:52:12.8110950Z   public static let dependencies = Self(
2020-11-15T22:52:12.8111560Z                                    ^~~~~
2020-11-15T22:52:12.8170370Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/AllCollections.swift:2:35: warning: expression took 2090ms to type-check (limit: 200ms)
2020-11-15T22:52:12.8254220Z   public static let all: [Self] = [
2020-11-15T22:52:12.8263380Z                                   ^
2020-11-15T22:52:12.8265950Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:3:5: warning: expression took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.8282340Z     Self(
2020-11-15T22:52:12.8282810Z     ^~~~~
2020-11-15T22:52:12.8284430Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:2:35: warning: getter 'parsing' took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.8285590Z   public static var parsing: Self {
2020-11-15T22:52:12.8286120Z                                   ^
2020-11-15T22:52:12.8287530Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/MapZipFlatMap.swift:2:37: warning: expression took 469ms to type-check (limit: 200ms)
2020-11-15T22:52:12.8288630Z   public static let mapZipFlatMap = Self(
2020-11-15T22:52:12.8289190Z                                     ^~~~~
2020-11-15T22:52:12.8290540Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Randomness.swift:2:34: warning: expression took 584ms to type-check (limit: 200ms)
2020-11-15T22:52:12.8291600Z   public static let randomness = Self(
2020-11-15T22:52:12.8292130Z                                  ^~~~~
2020-11-15T22:52:12.8293450Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Combine.swift:2:31: warning: expression took 208ms to type-check (limit: 200ms)
2020-11-15T22:52:12.8294460Z   public static let combine = Self(
2020-11-15T22:52:12.8294980Z                               ^~~~~
2020-11-15T22:52:12.8296460Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/ComposableArchitecture.swift:2:46: warning: expression took 794ms to type-check (limit: 200ms)
2020-11-15T22:52:12.8298020Z   public static let composableArchitecture = Self(
2020-11-15T22:52:12.8310010Z                                              ^~~~~
2020-11-15T22:52:12.8353100Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Dependencies.swift:2:36: warning: expression took 939ms to type-check (limit: 200ms)
2020-11-15T22:52:12.8354780Z   public static let dependencies = Self(
2020-11-15T22:52:12.8478200Z                                    ^~~~~
2020-11-15T22:52:12.8581450Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/AllCollections.swift:2:35: warning: expression took 2090ms to type-check (limit: 200ms)
2020-11-15T22:52:12.8684710Z   public static let all: [Self] = [
2020-11-15T22:52:12.8785950Z                                   ^
2020-11-15T22:52:12.8872860Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:3:5: warning: expression took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.8975020Z     Self(
2020-11-15T22:52:12.9063340Z     ^~~~~
2020-11-15T22:52:12.9103000Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:2:35: warning: getter 'parsing' took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9144020Z   public static var parsing: Self {
2020-11-15T22:52:12.9144700Z                                   ^
2020-11-15T22:52:12.9146520Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/MapZipFlatMap.swift:2:37: warning: expression took 469ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9147870Z   public static let mapZipFlatMap = Self(
2020-11-15T22:52:12.9148450Z                                     ^~~~~
2020-11-15T22:52:12.9149840Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Randomness.swift:2:34: warning: expression took 584ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9150880Z   public static let randomness = Self(
2020-11-15T22:52:12.9151390Z                                  ^~~~~
2020-11-15T22:52:12.9152690Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Combine.swift:2:31: warning: expression took 208ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9153680Z   public static let combine = Self(
2020-11-15T22:52:12.9154170Z                               ^~~~~
2020-11-15T22:52:12.9155630Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/ComposableArchitecture.swift:2:46: warning: expression took 794ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9156870Z   public static let composableArchitecture = Self(
2020-11-15T22:52:12.9157490Z                                              ^~~~~
2020-11-15T22:52:12.9210500Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Dependencies.swift:2:36: warning: expression took 939ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9254720Z   public static let dependencies = Self(
2020-11-15T22:52:12.9318060Z                                    ^~~~~
2020-11-15T22:52:12.9326270Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/AllCollections.swift:2:35: warning: expression took 2090ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9327340Z   public static let all: [Self] = [
2020-11-15T22:52:12.9327820Z                                   ^
2020-11-15T22:52:12.9329190Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:3:5: warning: expression took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9330100Z     Self(
2020-11-15T22:52:12.9330520Z     ^~~~~
2020-11-15T22:52:12.9331830Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:2:35: warning: getter 'parsing' took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9332820Z   public static var parsing: Self {
2020-11-15T22:52:12.9333300Z                                   ^
2020-11-15T22:52:12.9334650Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/MapZipFlatMap.swift:2:37: warning: expression took 469ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9335720Z   public static let mapZipFlatMap = Self(
2020-11-15T22:52:12.9336240Z                                     ^~~~~
2020-11-15T22:52:12.9337550Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Randomness.swift:2:34: warning: expression took 584ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9338710Z   public static let randomness = Self(
2020-11-15T22:52:12.9339220Z                                  ^~~~~
2020-11-15T22:52:12.9340950Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Combine.swift:2:31: warning: expression took 208ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9341980Z   public static let combine = Self(
2020-11-15T22:52:12.9342450Z                               ^~~~~
2020-11-15T22:52:12.9343920Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/ComposableArchitecture.swift:2:46: warning: expression took 794ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9345190Z   public static let composableArchitecture = Self(
2020-11-15T22:52:12.9345810Z                                              ^~~~~
2020-11-15T22:52:12.9347360Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Dependencies.swift:2:36: warning: expression took 939ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9363140Z   public static let dependencies = Self(
2020-11-15T22:52:12.9462050Z                                    ^~~~~
2020-11-15T22:52:12.9514420Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/AllCollections.swift:2:35: warning: expression took 2090ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9564660Z   public static let all: [Self] = [
2020-11-15T22:52:12.9587540Z                                   ^
2020-11-15T22:52:12.9589410Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:3:5: warning: expression took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9590350Z     Self(
2020-11-15T22:52:12.9590770Z     ^~~~~
2020-11-15T22:52:12.9592090Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:2:35: warning: getter 'parsing' took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9593090Z   public static var parsing: Self {
2020-11-15T22:52:12.9593580Z                                   ^
2020-11-15T22:52:12.9594970Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/MapZipFlatMap.swift:2:37: warning: expression took 469ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9596040Z   public static let mapZipFlatMap = Self(
2020-11-15T22:52:12.9596560Z                                     ^~~~~
2020-11-15T22:52:12.9597880Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Randomness.swift:2:34: warning: expression took 584ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9598900Z   public static let randomness = Self(
2020-11-15T22:52:12.9599400Z                                  ^~~~~
2020-11-15T22:52:12.9600690Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Combine.swift:2:31: warning: expression took 208ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9601680Z   public static let combine = Self(
2020-11-15T22:52:12.9602180Z                               ^~~~~
2020-11-15T22:52:12.9603640Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/ComposableArchitecture.swift:2:46: warning: expression took 794ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9604900Z   public static let composableArchitecture = Self(
2020-11-15T22:52:12.9605520Z                                              ^~~~~
2020-11-15T22:52:12.9606870Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Dependencies.swift:2:36: warning: expression took 939ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9608020Z   public static let dependencies = Self(
2020-11-15T22:52:12.9608540Z                                    ^~~~~
2020-11-15T22:52:12.9609910Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/AllCollections.swift:2:35: warning: expression took 2090ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9610950Z   public static let all: [Self] = [
2020-11-15T22:52:12.9611430Z                                   ^
2020-11-15T22:52:12.9612740Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:3:5: warning: expression took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9613660Z     Self(
2020-11-15T22:52:12.9614060Z     ^~~~~
2020-11-15T22:52:12.9615350Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:2:35: warning: getter 'parsing' took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9616790Z   public static var parsing: Self {
2020-11-15T22:52:12.9617420Z                                   ^
2020-11-15T22:52:12.9619040Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/MapZipFlatMap.swift:2:37: warning: expression took 469ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9620150Z   public static let mapZipFlatMap = Self(
2020-11-15T22:52:12.9620690Z                                     ^~~~~
2020-11-15T22:52:12.9622060Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Randomness.swift:2:34: warning: expression took 584ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9623380Z   public static let randomness = Self(
2020-11-15T22:52:12.9623890Z                                  ^~~~~
2020-11-15T22:52:12.9625210Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Combine.swift:2:31: warning: expression took 208ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9626200Z   public static let combine = Self(
2020-11-15T22:52:12.9626690Z                               ^~~~~
2020-11-15T22:52:12.9628290Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/ComposableArchitecture.swift:2:46: warning: expression took 794ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9629540Z   public static let composableArchitecture = Self(
2020-11-15T22:52:12.9630150Z                                              ^~~~~
2020-11-15T22:52:12.9631500Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Dependencies.swift:2:36: warning: expression took 939ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9632550Z   public static let dependencies = Self(
2020-11-15T22:52:12.9633070Z                                    ^~~~~
2020-11-15T22:52:12.9634440Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/AllCollections.swift:2:35: warning: expression took 2090ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9635470Z   public static let all: [Self] = [
2020-11-15T22:52:12.9635960Z                                   ^
2020-11-15T22:52:12.9637340Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:3:5: warning: expression took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9638270Z     Self(
2020-11-15T22:52:12.9638680Z     ^~~~~
2020-11-15T22:52:12.9639980Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:2:35: warning: getter 'parsing' took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9640970Z   public static var parsing: Self {
2020-11-15T22:52:12.9641460Z                                   ^
2020-11-15T22:52:12.9642820Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/MapZipFlatMap.swift:2:37: warning: expression took 469ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9643900Z   public static let mapZipFlatMap = Self(
2020-11-15T22:52:12.9644440Z                                     ^~~~~
2020-11-15T22:52:12.9645780Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Randomness.swift:2:34: warning: expression took 584ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9646800Z   public static let randomness = Self(
2020-11-15T22:52:12.9647410Z                                  ^~~~~
2020-11-15T22:52:12.9648700Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Combine.swift:2:31: warning: expression took 208ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9649690Z   public static let combine = Self(
2020-11-15T22:52:12.9650180Z                               ^~~~~
2020-11-15T22:52:12.9651630Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/ComposableArchitecture.swift:2:46: warning: expression took 794ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9652900Z   public static let composableArchitecture = Self(
2020-11-15T22:52:12.9653510Z                                              ^~~~~
2020-11-15T22:52:12.9655150Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Dependencies.swift:2:36: warning: expression took 939ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9656240Z   public static let dependencies = Self(
2020-11-15T22:52:12.9656760Z                                    ^~~~~
2020-11-15T22:52:12.9658140Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/AllCollections.swift:2:35: warning: expression took 2090ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9659180Z   public static let all: [Self] = [
2020-11-15T22:52:12.9659650Z                                   ^
2020-11-15T22:52:12.9660950Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:3:5: warning: expression took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9662070Z     Self(
2020-11-15T22:52:12.9662480Z     ^~~~~
2020-11-15T22:52:12.9663790Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:2:35: warning: getter 'parsing' took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9664770Z   public static var parsing: Self {
2020-11-15T22:52:12.9665260Z                                   ^
2020-11-15T22:52:12.9666620Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/MapZipFlatMap.swift:2:37: warning: expression took 469ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9667690Z   public static let mapZipFlatMap = Self(
2020-11-15T22:52:12.9668220Z                                     ^~~~~
2020-11-15T22:52:12.9669530Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Randomness.swift:2:34: warning: expression took 584ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9670550Z   public static let randomness = Self(
2020-11-15T22:52:12.9671070Z                                  ^~~~~
2020-11-15T22:52:12.9672370Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Combine.swift:2:31: warning: expression took 208ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9673350Z   public static let combine = Self(
2020-11-15T22:52:12.9673850Z                               ^~~~~
2020-11-15T22:52:12.9675310Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/ComposableArchitecture.swift:2:46: warning: expression took 794ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9676570Z   public static let composableArchitecture = Self(
2020-11-15T22:52:12.9677270Z                                              ^~~~~
2020-11-15T22:52:12.9678630Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Dependencies.swift:2:36: warning: expression took 939ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9679670Z   public static let dependencies = Self(
2020-11-15T22:52:12.9680190Z                                    ^~~~~
2020-11-15T22:52:12.9681680Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/AllCollections.swift:2:35: warning: expression took 2090ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9682710Z   public static let all: [Self] = [
2020-11-15T22:52:12.9683170Z                                   ^
2020-11-15T22:52:12.9684470Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:3:5: warning: expression took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9685390Z     Self(
2020-11-15T22:52:12.9685810Z     ^~~~~
2020-11-15T22:52:12.9687100Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:2:35: warning: getter 'parsing' took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9688080Z   public static var parsing: Self {
2020-11-15T22:52:12.9688570Z                                   ^
2020-11-15T22:52:12.9689930Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/MapZipFlatMap.swift:2:37: warning: expression took 469ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9691000Z   public static let mapZipFlatMap = Self(
2020-11-15T22:52:12.9691530Z                                     ^~~~~
2020-11-15T22:52:12.9693050Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Randomness.swift:2:34: warning: expression took 584ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9694110Z   public static let randomness = Self(
2020-11-15T22:52:12.9694610Z                                  ^~~~~
2020-11-15T22:52:12.9695920Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Combine.swift:2:31: warning: expression took 208ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9696900Z   public static let combine = Self(
2020-11-15T22:52:12.9697390Z                               ^~~~~
2020-11-15T22:52:12.9698850Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/ComposableArchitecture.swift:2:46: warning: expression took 794ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9700300Z   public static let composableArchitecture = Self(
2020-11-15T22:52:12.9700900Z                                              ^~~~~
2020-11-15T22:52:12.9702260Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Dependencies.swift:2:36: warning: expression took 939ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9717760Z   public static let dependencies = Self(
2020-11-15T22:52:12.9766040Z                                    ^~~~~
2020-11-15T22:52:12.9800790Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/AllCollections.swift:2:35: warning: expression took 2090ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9801990Z   public static let all: [Self] = [
2020-11-15T22:52:12.9802490Z                                   ^
2020-11-15T22:52:12.9805260Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:3:5: warning: expression took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9822400Z     Self(
2020-11-15T22:52:12.9875090Z     ^~~~~
2020-11-15T22:52:12.9877130Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:2:35: warning: getter 'parsing' took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9878160Z   public static var parsing: Self {
2020-11-15T22:52:12.9878660Z                                   ^
2020-11-15T22:52:12.9880070Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/MapZipFlatMap.swift:2:37: warning: expression took 469ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9881150Z   public static let mapZipFlatMap = Self(
2020-11-15T22:52:12.9881690Z                                     ^~~~~
2020-11-15T22:52:12.9883000Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Randomness.swift:2:34: warning: expression took 584ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9884030Z   public static let randomness = Self(
2020-11-15T22:52:12.9884540Z                                  ^~~~~
2020-11-15T22:52:12.9885840Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Combine.swift:2:31: warning: expression took 208ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9886850Z   public static let combine = Self(
2020-11-15T22:52:12.9887340Z                               ^~~~~
2020-11-15T22:52:12.9888810Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/ComposableArchitecture.swift:2:46: warning: expression took 794ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9890070Z   public static let composableArchitecture = Self(
2020-11-15T22:52:12.9890690Z                                              ^~~~~
2020-11-15T22:52:12.9892040Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Dependencies.swift:2:36: warning: expression took 939ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9893090Z   public static let dependencies = Self(
2020-11-15T22:52:12.9893610Z                                    ^~~~~
2020-11-15T22:52:12.9894980Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/AllCollections.swift:2:35: warning: expression took 2090ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9896020Z   public static let all: [Self] = [
2020-11-15T22:52:12.9896490Z                                   ^
2020-11-15T22:52:12.9898120Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:3:5: warning: expression took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9899070Z     Self(
2020-11-15T22:52:12.9899490Z     ^~~~~
2020-11-15T22:52:12.9900900Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:2:35: warning: getter 'parsing' took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9901890Z   public static var parsing: Self {
2020-11-15T22:52:12.9902380Z                                   ^
2020-11-15T22:52:12.9903760Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/MapZipFlatMap.swift:2:37: warning: expression took 469ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9905050Z   public static let mapZipFlatMap = Self(
2020-11-15T22:52:12.9905580Z                                     ^~~~~
2020-11-15T22:52:12.9906920Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Randomness.swift:2:34: warning: expression took 584ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9908020Z   public static let randomness = Self(
2020-11-15T22:52:12.9908540Z                                  ^~~~~
2020-11-15T22:52:12.9909840Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Combine.swift:2:31: warning: expression took 208ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9910830Z   public static let combine = Self(
2020-11-15T22:52:12.9911310Z                               ^~~~~
2020-11-15T22:52:12.9912760Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/ComposableArchitecture.swift:2:46: warning: expression took 794ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9914010Z   public static let composableArchitecture = Self(
2020-11-15T22:52:12.9914630Z                                              ^~~~~
2020-11-15T22:52:12.9915990Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Dependencies.swift:2:36: warning: expression took 939ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9917040Z   public static let dependencies = Self(
2020-11-15T22:52:12.9917560Z                                    ^~~~~
2020-11-15T22:52:12.9918920Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/AllCollections.swift:2:35: warning: expression took 2090ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9919950Z   public static let all: [Self] = [
2020-11-15T22:52:12.9920430Z                                   ^
2020-11-15T22:52:12.9921730Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:3:5: warning: expression took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9922640Z     Self(
2020-11-15T22:52:12.9923050Z     ^~~~~
2020-11-15T22:52:12.9924590Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:2:35: warning: getter 'parsing' took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9925640Z   public static var parsing: Self {
2020-11-15T22:52:12.9926150Z                                   ^
2020-11-15T22:52:12.9927530Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/MapZipFlatMap.swift:2:37: warning: expression took 469ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9929000Z   public static let mapZipFlatMap = Self(
2020-11-15T22:52:12.9929770Z                                     ^~~~~
2020-11-15T22:52:12.9931220Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Randomness.swift:2:34: warning: expression took 584ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9932250Z   public static let randomness = Self(
2020-11-15T22:52:12.9933000Z                                  ^~~~~
2020-11-15T22:52:12.9934340Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Combine.swift:2:31: warning: expression took 208ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9935470Z   public static let combine = Self(
2020-11-15T22:52:12.9935940Z                               ^~~~~
2020-11-15T22:52:12.9938200Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/ComposableArchitecture.swift:2:46: warning: expression took 794ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9939510Z   public static let composableArchitecture = Self(
2020-11-15T22:52:12.9940130Z                                              ^~~~~
2020-11-15T22:52:12.9941490Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Dependencies.swift:2:36: warning: expression took 939ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9942540Z   public static let dependencies = Self(
2020-11-15T22:52:12.9943070Z                                    ^~~~~
2020-11-15T22:52:12.9944420Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/AllCollections.swift:2:35: warning: expression took 2090ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9945660Z   public static let all: [Self] = [
2020-11-15T22:52:12.9946150Z                                   ^
2020-11-15T22:52:12.9947510Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:3:5: warning: expression took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9948440Z     Self(
2020-11-15T22:52:12.9948860Z     ^~~~~
2020-11-15T22:52:12.9950160Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:2:35: warning: getter 'parsing' took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9951140Z   public static var parsing: Self {
2020-11-15T22:52:12.9951630Z                                   ^
2020-11-15T22:52:12.9952980Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/MapZipFlatMap.swift:2:37: warning: expression took 469ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9954040Z   public static let mapZipFlatMap = Self(
2020-11-15T22:52:12.9954550Z                                     ^~~~~
2020-11-15T22:52:12.9955990Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Randomness.swift:2:34: warning: expression took 584ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9957010Z   public static let randomness = Self(
2020-11-15T22:52:12.9957520Z                                  ^~~~~
2020-11-15T22:52:12.9959520Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Combine.swift:2:31: warning: expression took 208ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9960520Z   public static let combine = Self(
2020-11-15T22:52:12.9961020Z                               ^~~~~
2020-11-15T22:52:12.9962480Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/ComposableArchitecture.swift:2:46: warning: expression took 794ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9963740Z   public static let composableArchitecture = Self(
2020-11-15T22:52:12.9964350Z                                              ^~~~~
2020-11-15T22:52:12.9965710Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Dependencies.swift:2:36: warning: expression took 939ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9966760Z   public static let dependencies = Self(
2020-11-15T22:52:12.9967280Z                                    ^~~~~
2020-11-15T22:52:12.9968660Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/AllCollections.swift:2:35: warning: expression took 2090ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9969690Z   public static let all: [Self] = [
2020-11-15T22:52:12.9970160Z                                   ^
2020-11-15T22:52:12.9971450Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:3:5: warning: expression took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9972360Z     Self(
2020-11-15T22:52:12.9972770Z     ^~~~~
2020-11-15T22:52:12.9974050Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:2:35: warning: getter 'parsing' took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9975040Z   public static var parsing: Self {
2020-11-15T22:52:12.9975530Z                                   ^
2020-11-15T22:52:12.9976870Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/MapZipFlatMap.swift:2:37: warning: expression took 469ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9978160Z   public static let mapZipFlatMap = Self(
2020-11-15T22:52:12.9978750Z                                     ^~~~~
2020-11-15T22:52:12.9980080Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Randomness.swift:2:34: warning: expression took 584ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9981100Z   public static let randomness = Self(
2020-11-15T22:52:12.9981610Z                                  ^~~~~
2020-11-15T22:52:12.9982890Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Combine.swift:2:31: warning: expression took 208ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9984070Z   public static let combine = Self(
2020-11-15T22:52:12.9984560Z                               ^~~~~
2020-11-15T22:52:12.9986020Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/ComposableArchitecture.swift:2:46: warning: expression took 794ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9987270Z   public static let composableArchitecture = Self(
2020-11-15T22:52:12.9987880Z                                              ^~~~~
2020-11-15T22:52:12.9989220Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Dependencies.swift:2:36: warning: expression took 939ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9990260Z   public static let dependencies = Self(
2020-11-15T22:52:12.9990790Z                                    ^~~~~
2020-11-15T22:52:12.9992140Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/AllCollections.swift:2:35: warning: expression took 2090ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9993160Z   public static let all: [Self] = [
2020-11-15T22:52:12.9993650Z                                   ^
2020-11-15T22:52:12.9994940Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:3:5: warning: expression took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9995840Z     Self(
2020-11-15T22:52:12.9996240Z     ^~~~~
2020-11-15T22:52:12.9997540Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:2:35: warning: getter 'parsing' took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:12.9998520Z   public static var parsing: Self {
2020-11-15T22:52:12.9999010Z                                   ^
2020-11-15T22:52:13.0000370Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/MapZipFlatMap.swift:2:37: warning: expression took 469ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0001440Z   public static let mapZipFlatMap = Self(
2020-11-15T22:52:13.0001970Z                                     ^~~~~
2020-11-15T22:52:13.0003280Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Randomness.swift:2:34: warning: expression took 584ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0004300Z   public static let randomness = Self(
2020-11-15T22:52:13.0004810Z                                  ^~~~~
2020-11-15T22:52:13.0006090Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Combine.swift:2:31: warning: expression took 208ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0007070Z   public static let combine = Self(
2020-11-15T22:52:13.0007560Z                               ^~~~~
2020-11-15T22:52:13.0009080Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/ComposableArchitecture.swift:2:46: warning: expression took 794ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0010320Z   public static let composableArchitecture = Self(
2020-11-15T22:52:13.0010940Z                                              ^~~~~
2020-11-15T22:52:13.0012270Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Dependencies.swift:2:36: warning: expression took 939ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0013310Z   public static let dependencies = Self(
2020-11-15T22:52:13.0013830Z                                    ^~~~~
2020-11-15T22:52:13.0015330Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/AllCollections.swift:2:35: warning: expression took 2090ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0016400Z   public static let all: [Self] = [
2020-11-15T22:52:13.0016880Z                                   ^
2020-11-15T22:52:13.0018170Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:3:5: warning: expression took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0019080Z     Self(
2020-11-15T22:52:13.0019500Z     ^~~~~
2020-11-15T22:52:13.0020780Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:2:35: warning: getter 'parsing' took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0022150Z   public static var parsing: Self {
2020-11-15T22:52:13.0022650Z                                   ^
2020-11-15T22:52:13.0024010Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/MapZipFlatMap.swift:2:37: warning: expression took 469ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0024850Z   public static let mapZipFlatMap = Self(
2020-11-15T22:52:13.0025420Z                                     ^~~~~
2020-11-15T22:52:13.0026750Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Randomness.swift:2:34: warning: expression took 584ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0027760Z   public static let randomness = Self(
2020-11-15T22:52:13.0028270Z                                  ^~~~~
2020-11-15T22:52:13.0029560Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Combine.swift:2:31: warning: expression took 208ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0030540Z   public static let combine = Self(
2020-11-15T22:52:13.0031020Z                               ^~~~~
2020-11-15T22:52:13.0032490Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/ComposableArchitecture.swift:2:46: warning: expression took 794ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0033730Z   public static let composableArchitecture = Self(
2020-11-15T22:52:13.0034350Z                                              ^~~~~
2020-11-15T22:52:13.0036310Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Dependencies.swift:2:36: warning: expression took 939ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0135730Z   public static let dependencies = Self(
2020-11-15T22:52:13.0136950Z                                    ^~~~~
2020-11-15T22:52:13.0239060Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/AllCollections.swift:2:35: warning: expression took 2090ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0240010Z   public static let all: [Self] = [
2020-11-15T22:52:13.0240250Z                                   ^
2020-11-15T22:52:13.0241380Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:3:5: warning: expression took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0242010Z     Self(
2020-11-15T22:52:13.0242190Z     ^~~~~
2020-11-15T22:52:13.0243250Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:2:35: warning: getter 'parsing' took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0243950Z   public static var parsing: Self {
2020-11-15T22:52:13.0244210Z                                   ^
2020-11-15T22:52:13.0245300Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/MapZipFlatMap.swift:2:37: warning: expression took 469ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0246080Z   public static let mapZipFlatMap = Self(
2020-11-15T22:52:13.0246370Z                                     ^~~~~
2020-11-15T22:52:13.0247510Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Randomness.swift:2:34: warning: expression took 584ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0248250Z   public static let randomness = Self(
2020-11-15T22:52:13.0248520Z                                  ^~~~~
2020-11-15T22:52:13.0249570Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Combine.swift:2:31: warning: expression took 208ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0250550Z   public static let combine = Self(
2020-11-15T22:52:13.0250850Z                               ^~~~~
2020-11-15T22:52:13.0252090Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/ComposableArchitecture.swift:2:46: warning: expression took 794ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0253040Z   public static let composableArchitecture = Self(
2020-11-15T22:52:13.0253420Z                                              ^~~~~
2020-11-15T22:52:13.0254480Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Dependencies.swift:2:36: warning: expression took 939ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0255450Z   public static let dependencies = Self(
2020-11-15T22:52:13.0255740Z                                    ^~~~~
2020-11-15T22:52:13.0256880Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/AllCollections.swift:2:35: warning: expression took 2090ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0257630Z   public static let all: [Self] = [
2020-11-15T22:52:13.0257880Z                                   ^
2020-11-15T22:52:13.0258910Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:3:5: warning: expression took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0259530Z     Self(
2020-11-15T22:52:13.0259710Z     ^~~~~
2020-11-15T22:52:13.0260720Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:2:35: warning: getter 'parsing' took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0261410Z   public static var parsing: Self {
2020-11-15T22:52:13.0261670Z                                   ^
2020-11-15T22:52:13.0262760Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/MapZipFlatMap.swift:2:37: warning: expression took 469ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0263540Z   public static let mapZipFlatMap = Self(
2020-11-15T22:52:13.0263830Z                                     ^~~~~
2020-11-15T22:52:13.0264890Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Randomness.swift:2:34: warning: expression took 584ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0265620Z   public static let randomness = Self(
2020-11-15T22:52:13.0265890Z                                  ^~~~~
2020-11-15T22:52:13.0266920Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Combine.swift:2:31: warning: expression took 208ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0267590Z   public static let combine = Self(
2020-11-15T22:52:13.0267850Z                               ^~~~~
2020-11-15T22:52:13.0269040Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/ComposableArchitecture.swift:2:46: warning: expression took 794ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0270000Z   public static let composableArchitecture = Self(
2020-11-15T22:52:13.0270380Z                                              ^~~~~
2020-11-15T22:52:13.0271460Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Dependencies.swift:2:36: warning: expression took 939ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0272210Z   public static let dependencies = Self(
2020-11-15T22:52:13.0272500Z                                    ^~~~~
2020-11-15T22:52:13.0273590Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/AllCollections.swift:2:35: warning: expression took 2090ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0274320Z   public static let all: [Self] = [
2020-11-15T22:52:13.0274550Z                                   ^
2020-11-15T22:52:13.0275570Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:3:5: warning: expression took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0276200Z     Self(
2020-11-15T22:52:13.0276390Z     ^~~~~
2020-11-15T22:52:13.0277500Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:2:35: warning: getter 'parsing' took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0278420Z   public static var parsing: Self {
2020-11-15T22:52:13.0278710Z                                   ^
2020-11-15T22:52:13.0279840Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/MapZipFlatMap.swift:2:37: warning: expression took 469ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0280620Z   public static let mapZipFlatMap = Self(
2020-11-15T22:52:13.0280900Z                                     ^~~~~
2020-11-15T22:52:13.0281950Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Randomness.swift:2:34: warning: expression took 584ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0282870Z   public static let randomness = Self(
2020-11-15T22:52:13.0283150Z                                  ^~~~~
2020-11-15T22:52:13.0284210Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Combine.swift:2:31: warning: expression took 208ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0284910Z   public static let combine = Self(
2020-11-15T22:52:13.0285170Z                               ^~~~~
2020-11-15T22:52:13.0286360Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/ComposableArchitecture.swift:2:46: warning: expression took 794ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0287310Z   public static let composableArchitecture = Self(
2020-11-15T22:52:13.0287690Z                                              ^~~~~
2020-11-15T22:52:13.0288760Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Dependencies.swift:2:36: warning: expression took 939ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0289520Z   public static let dependencies = Self(
2020-11-15T22:52:13.0289820Z                                    ^~~~~
2020-11-15T22:52:13.0290910Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/AllCollections.swift:2:35: warning: expression took 2090ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0291650Z   public static let all: [Self] = [
2020-11-15T22:52:13.0291900Z                                   ^
2020-11-15T22:52:13.0292930Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:3:5: warning: expression took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0293550Z     Self(
2020-11-15T22:52:13.0293730Z     ^~~~~
2020-11-15T22:52:13.0294740Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:2:35: warning: getter 'parsing' took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0295430Z   public static var parsing: Self {
2020-11-15T22:52:13.0295690Z                                   ^
2020-11-15T22:52:13.0296950Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/MapZipFlatMap.swift:2:37: warning: expression took 469ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0299420Z   public static let mapZipFlatMap = Self(
2020-11-15T22:52:13.0299740Z                                     ^~~~~
2020-11-15T22:52:13.0301030Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Randomness.swift:2:34: warning: expression took 584ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0301760Z   public static let randomness = Self(
2020-11-15T22:52:13.0302040Z                                  ^~~~~
2020-11-15T22:52:13.0303080Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Combine.swift:2:31: warning: expression took 208ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0303760Z   public static let combine = Self(
2020-11-15T22:52:13.0304020Z                               ^~~~~
2020-11-15T22:52:13.0305210Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/ComposableArchitecture.swift:2:46: warning: expression took 794ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0306180Z   public static let composableArchitecture = Self(
2020-11-15T22:52:13.0306560Z                                              ^~~~~
2020-11-15T22:52:13.0307970Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Dependencies.swift:2:36: warning: expression took 939ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0308760Z   public static let dependencies = Self(
2020-11-15T22:52:13.0309050Z                                    ^~~~~
2020-11-15T22:52:13.0310190Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/AllCollections.swift:2:35: warning: expression took 2090ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0310920Z   public static let all: [Self] = [
2020-11-15T22:52:13.0311150Z                                   ^
2020-11-15T22:52:13.0312180Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:3:5: warning: expression took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0312980Z     Self(
2020-11-15T22:52:13.0313160Z     ^~~~~
2020-11-15T22:52:13.0314230Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Collections/Parsing.swift:2:35: warning: getter 'parsing' took 203ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0314920Z   public static var parsing: Self {
2020-11-15T22:52:13.0315190Z                                   ^
2020-11-15T22:52:13.0315610Z [460/567] Compiling Core DispatchTime+Utilities.swift
2020-11-15T22:52:13.0316200Z [461/567] Compiling Core EmptyInitializable.swift
2020-11-15T22:52:13.0316660Z [462/567] Compiling Core Exports.swift
2020-11-15T22:52:13.0317040Z [463/567] Compiling Core Extendable.swift
2020-11-15T22:52:13.0317470Z [464/567] Compiling Core FileProtocol.swift
2020-11-15T22:52:13.0317860Z [465/567] Compiling Core Int+Hex.swift
2020-11-15T22:52:13.0318810Z [466/567] Compiling Models 0096-AdaptiveStateManagementPt3.swift
2020-11-15T22:52:13.0320270Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0111-DesigningDependencies.swift:4:55: warning: expression took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0321230Z   public static let ep111_designingDependencies_pt2 = Episode(
2020-11-15T22:52:13.0321630Z                                                       ^~~~~~~~
2020-11-15T22:52:13.0322470Z [467/567] Compiling Models 0097-AdaptiveStateManagementPt4.swift
2020-11-15T22:52:13.0323930Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0111-DesigningDependencies.swift:4:55: warning: expression took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0324880Z   public static let ep111_designingDependencies_pt2 = Episode(
2020-11-15T22:52:13.0325280Z                                                       ^~~~~~~~
2020-11-15T22:52:13.0326130Z [468/567] Compiling Models 0098-ErgonomicStateManagementPt1.swift
2020-11-15T22:52:13.0327610Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0111-DesigningDependencies.swift:4:55: warning: expression took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0328560Z   public static let ep111_designingDependencies_pt2 = Episode(
2020-11-15T22:52:13.0328960Z                                                       ^~~~~~~~
2020-11-15T22:52:13.0329830Z [469/567] Compiling Models 0099-ErgonomicStateManagementPt2.swift
2020-11-15T22:52:13.0331300Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0111-DesigningDependencies.swift:4:55: warning: expression took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0332240Z   public static let ep111_designingDependencies_pt2 = Episode(
2020-11-15T22:52:13.0332630Z                                                       ^~~~~~~~
2020-11-15T22:52:13.0333630Z [470/567] Compiling Models 0100-ATourOfTheComposableArchitecturePt1.swift
2020-11-15T22:52:13.0335240Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0111-DesigningDependencies.swift:4:55: warning: expression took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0336190Z   public static let ep111_designingDependencies_pt2 = Episode(
2020-11-15T22:52:13.0336590Z                                                       ^~~~~~~~
2020-11-15T22:52:13.0337700Z [471/567] Compiling Models 0101-ATourOfTheComposableArchitecturePt2.swift
2020-11-15T22:52:13.0339680Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0111-DesigningDependencies.swift:4:55: warning: expression took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0340650Z   public static let ep111_designingDependencies_pt2 = Episode(
2020-11-15T22:52:13.0341050Z                                                       ^~~~~~~~
2020-11-15T22:52:13.0342090Z [472/567] Compiling Models 0102-ATourOfTheComposableArchitecturePt3.swift
2020-11-15T22:52:13.0343690Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0111-DesigningDependencies.swift:4:55: warning: expression took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0344620Z   public static let ep111_designingDependencies_pt2 = Episode(
2020-11-15T22:52:13.0345210Z                                                       ^~~~~~~~
2020-11-15T22:52:13.0346240Z [473/567] Compiling Models 0103-ATourOfTheComposableArchitecturePt4.swift
2020-11-15T22:52:13.0347960Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0111-DesigningDependencies.swift:4:55: warning: expression took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0348910Z   public static let ep111_designingDependencies_pt2 = Episode(
2020-11-15T22:52:13.0349310Z                                                       ^~~~~~~~
2020-11-15T22:52:13.0350190Z [474/567] Compiling Models 0104-CombineSchedulersTestingTime.swift
2020-11-15T22:52:13.0351680Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0111-DesigningDependencies.swift:4:55: warning: expression took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0352620Z   public static let ep111_designingDependencies_pt2 = Episode(
2020-11-15T22:52:13.0353020Z                                                       ^~~~~~~~
2020-11-15T22:52:13.0353980Z [475/567] Compiling Models 0105-CombineSchedulersControllingTime.swift
2020-11-15T22:52:13.0355540Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0111-DesigningDependencies.swift:4:55: warning: expression took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0356490Z   public static let ep111_designingDependencies_pt2 = Episode(
2020-11-15T22:52:13.0356890Z                                                       ^~~~~~~~
2020-11-15T22:52:13.0357780Z [476/567] Compiling Models 0106-CombineSchedulersErasingTime.swift
2020-11-15T22:52:13.0359270Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0111-DesigningDependencies.swift:4:55: warning: expression took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0360210Z   public static let ep111_designingDependencies_pt2 = Episode(
2020-11-15T22:52:13.0360610Z                                                       ^~~~~~~~
2020-11-15T22:52:13.0361450Z [477/567] Compiling Models 0107-ComposableSwiftUIBindings.swift
2020-11-15T22:52:13.0362910Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0111-DesigningDependencies.swift:4:55: warning: expression took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0363860Z   public static let ep111_designingDependencies_pt2 = Episode(
2020-11-15T22:52:13.0364260Z                                                       ^~~~~~~~
2020-11-15T22:52:13.0365100Z [478/567] Compiling Models 0108-ComposableSwiftUIBindings.swift
2020-11-15T22:52:13.0366550Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0111-DesigningDependencies.swift:4:55: warning: expression took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0367490Z   public static let ep111_designingDependencies_pt2 = Episode(
2020-11-15T22:52:13.0367890Z                                                       ^~~~~~~~
2020-11-15T22:52:13.0368730Z [479/567] Compiling Models 0109-ComposableSwiftUIBindings.swift
2020-11-15T22:52:13.0370180Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0111-DesigningDependencies.swift:4:55: warning: expression took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0371120Z   public static let ep111_designingDependencies_pt2 = Episode(
2020-11-15T22:52:13.0371520Z                                                       ^~~~~~~~
2020-11-15T22:52:13.0372570Z [480/567] Compiling Models 0110-DesigningDependencies.swift
2020-11-15T22:52:13.0374010Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0111-DesigningDependencies.swift:4:55: warning: expression took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0374960Z   public static let ep111_designingDependencies_pt2 = Episode(
2020-11-15T22:52:13.0375360Z                                                       ^~~~~~~~
2020-11-15T22:52:13.0376140Z [481/567] Compiling Models 0111-DesigningDependencies.swift
2020-11-15T22:52:13.0377620Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0111-DesigningDependencies.swift:4:55: warning: expression took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0378780Z   public static let ep111_designingDependencies_pt2 = Episode(
2020-11-15T22:52:13.0379180Z                                                       ^~~~~~~~
2020-11-15T22:52:13.0380000Z [482/567] Compiling Models 0112-DesigningDependencies.swift
2020-11-15T22:52:13.0381400Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0111-DesigningDependencies.swift:4:55: warning: expression took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0382340Z   public static let ep111_designingDependencies_pt2 = Episode(
2020-11-15T22:52:13.0382740Z                                                       ^~~~~~~~
2020-11-15T22:52:13.0383510Z [483/567] Compiling Models 0113-DesigningDependencies.swift
2020-11-15T22:52:13.0384900Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0111-DesigningDependencies.swift:4:55: warning: expression took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0385850Z   public static let ep111_designingDependencies_pt2 = Episode(
2020-11-15T22:52:13.0386250Z                                                       ^~~~~~~~
2020-11-15T22:52:13.0387020Z [484/567] Compiling Models 0114-DesigningDependencies.swift
2020-11-15T22:52:13.0388410Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0111-DesigningDependencies.swift:4:55: warning: expression took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0389350Z   public static let ep111_designingDependencies_pt2 = Episode(
2020-11-15T22:52:13.0389750Z                                                       ^~~~~~~~
2020-11-15T22:52:13.0390460Z [485/567] Compiling Models 0115-RedactedSwiftUI.swift
2020-11-15T22:52:13.0391780Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0111-DesigningDependencies.swift:4:55: warning: expression took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0392720Z   public static let ep111_designingDependencies_pt2 = Episode(
2020-11-15T22:52:13.0393110Z                                                       ^~~~~~~~
2020-11-15T22:52:13.0393820Z [486/567] Compiling Models 0116-RedactedSwiftUI.swift
2020-11-15T22:52:13.0395140Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0111-DesigningDependencies.swift:4:55: warning: expression took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0396090Z   public static let ep111_designingDependencies_pt2 = Episode(
2020-11-15T22:52:13.0396490Z                                                       ^~~~~~~~
2020-11-15T22:52:13.0397200Z [487/567] Compiling Models 0117-RedactedSwiftUI.swift
2020-11-15T22:52:13.0398520Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0111-DesigningDependencies.swift:4:55: warning: expression took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0399460Z   public static let ep111_designingDependencies_pt2 = Episode(
2020-11-15T22:52:13.0399860Z                                                       ^~~~~~~~
2020-11-15T22:52:13.0400580Z [488/567] Compiling Models 0118-RedactedSwiftUI.swift
2020-11-15T22:52:13.0401890Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0111-DesigningDependencies.swift:4:55: warning: expression took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:13.0402830Z   public static let ep111_designingDependencies_pt2 = Episode(
2020-11-15T22:52:13.0403420Z                                                       ^~~~~~~~
2020-11-15T22:52:13.0403730Z [489/567] Compiling Core Array.swift
2020-11-15T22:52:13.0404070Z [490/567] Compiling Core Bits.swift
2020-11-15T22:52:13.0404400Z [491/567] Compiling Core Cache.swift
2020-11-15T22:52:13.0404810Z [492/567] Compiling Core Collection+Safe.swift
2020-11-15T22:52:13.0405250Z [493/567] Compiling Core DataFile.swift
2020-11-15T22:52:13.0405620Z [494/567] Compiling Core Dispatch.swift
2020-11-15T22:52:13.0405970Z [501/567] Compiling Core Lock.swift
2020-11-15T22:52:13.0406310Z [502/567] Compiling Core Portal.swift
2020-11-15T22:52:13.0406640Z [503/567] Compiling Core RFC1123.swift
2020-11-15T22:52:13.0407240Z [504/567] Compiling Core Result.swift
2020-11-15T22:52:13.0407620Z [505/567] Compiling Core Semaphore.swift
2020-11-15T22:52:13.0408000Z [506/567] Compiling Core Sequence.swift
2020-11-15T22:52:13.0408450Z [519/567] Compiling Core StaticDataBuffer.swift
2020-11-15T22:52:13.0409130Z [520/567] Compiling Core String+CaseInsensitiveCompare.swift
2020-11-15T22:52:13.0409810Z [521/567] Compiling Core String+Polymorphic.swift
2020-11-15T22:52:13.0410260Z [522/567] Compiling Core String.swift
2020-11-15T22:52:13.0410690Z [523/567] Compiling Core WorkingDirectory.swift
2020-11-15T22:52:13.2045090Z [529/568] Compiling NIO DatagramVectorReadManager.swift
2020-11-15T22:52:13.2062690Z [530/568] Compiling NIO DeadChannel.swift
2020-11-15T22:52:13.2063970Z [531/568] Compiling NIO DispathQueue+WithFuture.swift
2020-11-15T22:52:13.2065110Z [532/568] Compiling NIO Embedded.swift
2020-11-15T22:52:13.2166220Z [533/568] Compiling NIO EventLoop.swift
2020-11-15T22:52:13.2218280Z [534/568] Compiling NIO EventLoopFuture.swift
2020-11-15T22:52:13.2219360Z [535/568] Compiling NIO FileDescriptor.swift
2020-11-15T22:52:13.2220210Z [536/568] Compiling NIO FileHandle.swift
2020-11-15T22:52:13.2221000Z [537/568] Compiling NIO FileRegion.swift
2020-11-15T22:52:13.2221880Z [538/568] Compiling NIO GetaddrinfoResolver.swift
2020-11-15T22:52:13.2222790Z [539/568] Compiling NIO HappyEyeballs.swift
2020-11-15T22:52:13.2223570Z [540/568] Compiling NIO Heap.swift
2020-11-15T22:52:13.2224290Z [541/568] Compiling NIO IO.swift
2020-11-15T22:52:13.2556730Z [542/569] Merging module Core
2020-11-15T22:52:13.6274410Z [543/575] Compiling ApplicativeRouter Combinators.swift
2020-11-15T22:52:14.0645200Z [544/576] Merging module StyleguideTests
2020-11-15T22:52:14.6294830Z [545/614] Merging module NIO
2020-11-15T22:52:14.7787240Z [546/623] Compiling NIOHTTP1 HTTPEncoder.swift
2020-11-15T22:52:14.7887900Z [547/623] Compiling NIOHTTP1 HTTPPipelineSetup.swift
2020-11-15T22:52:15.4611400Z [548/623] Compiling NIOHTTP1 ByteCollectionUtils.swift
2020-11-15T22:52:15.4713040Z [549/623] Compiling NIOHTTP1 HTTPDecoder.swift
2020-11-15T22:52:15.4814960Z [550/623] Compiling NIOHTTP1 HTTPServerProtocolErrorHandler.swift
2020-11-15T22:52:15.9061200Z [551/623] Compiling NIOHTTP1 HTTPServerPipelineHandler.swift
2020-11-15T22:52:16.1181960Z [555/624] Compiling NIOHTTP1 HTTPServerUpgradeHandler.swift
2020-11-15T22:52:16.3069720Z [556/624] Compiling Node UnsignedInteger+Convertible.swift
2020-11-15T22:52:16.3071010Z [557/624] Compiling Node Context.swift
2020-11-15T22:52:16.3071670Z [558/624] Compiling Node Node.swift
2020-11-15T22:52:16.3072400Z [559/624] Compiling Node NodeConvertible.swift
2020-11-15T22:52:16.3073210Z [560/624] Compiling Node NodeInitializable.swift
2020-11-15T22:52:16.3074040Z [561/624] Compiling Node NodeRepresentable.swift
2020-11-15T22:52:16.3074870Z [562/624] Compiling Node Array+Convertible.swift
2020-11-15T22:52:16.3075750Z [563/624] Compiling Node Dictionary+Convertible.swift
2020-11-15T22:52:16.3076580Z [564/624] Compiling Node Fuzzy+Any.swift
2020-11-15T22:52:16.3077410Z [565/624] Compiling Node FuzzyConverter.swift
2020-11-15T22:52:16.3415550Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/Convertibles/Date+Convertible.swift:71:22: warning: 'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value
2020-11-15T22:52:16.3528520Z                     .flatMap({ $0.date(from: string) })
2020-11-15T22:52:16.3529260Z                      ^
2020-11-15T22:52:16.3531030Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/Convertibles/Date+Convertible.swift:71:22: note: use 'compactMap(_:)' instead
2020-11-15T22:52:16.3532090Z                     .flatMap({ $0.date(from: string) })
2020-11-15T22:52:16.3532590Z                      ^~~~~~~
2020-11-15T22:52:16.3533040Z                      compactMap
2020-11-15T22:52:16.3534840Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/Convertibles/Date+Convertible.swift:71:22: warning: 'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value
2020-11-15T22:52:16.3536420Z                     .flatMap({ $0.date(from: string) })
2020-11-15T22:52:16.3536910Z                      ^
2020-11-15T22:52:16.3590950Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/Convertibles/Date+Convertible.swift:71:22: note: use 'compactMap(_:)' instead
2020-11-15T22:52:16.3592200Z                     .flatMap({ $0.date(from: string) })
2020-11-15T22:52:16.3592700Z                      ^~~~~~~
2020-11-15T22:52:16.3593140Z                      compactMap
2020-11-15T22:52:16.3594850Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/Convertibles/Date+Convertible.swift:71:22: warning: 'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value
2020-11-15T22:52:16.3596090Z                     .flatMap({ $0.date(from: string) })
2020-11-15T22:52:16.3596580Z                      ^
2020-11-15T22:52:16.3598360Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/Convertibles/Date+Convertible.swift:71:22: note: use 'compactMap(_:)' instead
2020-11-15T22:52:16.3599480Z                     .flatMap({ $0.date(from: string) })
2020-11-15T22:52:16.3600000Z                      ^~~~~~~
2020-11-15T22:52:16.3600470Z                      compactMap
2020-11-15T22:52:16.3602180Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/Convertibles/Date+Convertible.swift:71:22: warning: 'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value
2020-11-15T22:52:16.3603440Z                     .flatMap({ $0.date(from: string) })
2020-11-15T22:52:16.3603930Z                      ^
2020-11-15T22:52:16.3605310Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/Convertibles/Date+Convertible.swift:71:22: note: use 'compactMap(_:)' instead
2020-11-15T22:52:16.3606370Z                     .flatMap({ $0.date(from: string) })
2020-11-15T22:52:16.3606850Z                      ^~~~~~~
2020-11-15T22:52:16.3607300Z                      compactMap
2020-11-15T22:52:16.3608980Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/Convertibles/Date+Convertible.swift:71:22: warning: 'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value
2020-11-15T22:52:16.3610210Z                     .flatMap({ $0.date(from: string) })
2020-11-15T22:52:16.3610530Z                      ^
2020-11-15T22:52:16.3611830Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/Convertibles/Date+Convertible.swift:71:22: note: use 'compactMap(_:)' instead
2020-11-15T22:52:16.3612590Z                     .flatMap({ $0.date(from: string) })
2020-11-15T22:52:16.3612840Z                      ^~~~~~~
2020-11-15T22:52:16.3613060Z                      compactMap
2020-11-15T22:52:16.3614500Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/Convertibles/Date+Convertible.swift:71:22: warning: 'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value
2020-11-15T22:52:16.3615470Z                     .flatMap({ $0.date(from: string) })
2020-11-15T22:52:16.3615720Z                      ^
2020-11-15T22:52:16.3622580Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/Convertibles/Date+Convertible.swift:71:22: note: use 'compactMap(_:)' instead
2020-11-15T22:52:16.3623410Z                     .flatMap({ $0.date(from: string) })
2020-11-15T22:52:16.3623660Z                      ^~~~~~~
2020-11-15T22:52:16.3623870Z                      compactMap
2020-11-15T22:52:16.3625410Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/Convertibles/Date+Convertible.swift:71:22: warning: 'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value
2020-11-15T22:52:16.3664090Z                     .flatMap({ $0.date(from: string) })
2020-11-15T22:52:16.3664790Z                      ^
2020-11-15T22:52:16.3666640Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/Convertibles/Date+Convertible.swift:71:22: note: use 'compactMap(_:)' instead
2020-11-15T22:52:16.3667490Z                     .flatMap({ $0.date(from: string) })
2020-11-15T22:52:16.3667750Z                      ^~~~~~~
2020-11-15T22:52:16.3667970Z                      compactMap
2020-11-15T22:52:16.3668310Z [573/624] Compiling NIOHTTP1 HTTPTypes.swift
2020-11-15T22:52:16.3669870Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/Convertibles/Date+Convertible.swift:71:22: warning: 'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value
2020-11-15T22:52:16.3670860Z                     .flatMap({ $0.date(from: string) })
2020-11-15T22:52:16.3671100Z                      ^
2020-11-15T22:52:16.3672240Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/Convertibles/Date+Convertible.swift:71:22: note: use 'compactMap(_:)' instead
2020-11-15T22:52:16.3673000Z                     .flatMap({ $0.date(from: string) })
2020-11-15T22:52:16.3673250Z                      ^~~~~~~
2020-11-15T22:52:16.3673470Z                      compactMap
2020-11-15T22:52:16.3674030Z [574/624] Compiling NIOHTTP1 NIOHTTPClientUpgradeHandler.swift
2020-11-15T22:52:16.3676200Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/Convertibles/Date+Convertible.swift:71:22: warning: 'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value
2020-11-15T22:52:16.3677270Z                     .flatMap({ $0.date(from: string) })
2020-11-15T22:52:16.3677520Z                      ^
2020-11-15T22:52:16.3678830Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/Convertibles/Date+Convertible.swift:71:22: note: use 'compactMap(_:)' instead
2020-11-15T22:52:16.3679600Z                     .flatMap({ $0.date(from: string) })
2020-11-15T22:52:16.3679860Z                      ^~~~~~~
2020-11-15T22:52:16.3680070Z                      compactMap
2020-11-15T22:52:16.3680450Z [575/624] Compiling Node UUID+Convertible.swift
2020-11-15T22:52:16.3682030Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/Convertibles/Date+Convertible.swift:71:22: warning: 'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value
2020-11-15T22:52:16.3683000Z                     .flatMap({ $0.date(from: string) })
2020-11-15T22:52:16.3683250Z                      ^
2020-11-15T22:52:16.3684350Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/Convertibles/Date+Convertible.swift:71:22: note: use 'compactMap(_:)' instead
2020-11-15T22:52:16.3685110Z                     .flatMap({ $0.date(from: string) })
2020-11-15T22:52:16.3685360Z                      ^~~~~~~
2020-11-15T22:52:16.3685580Z                      compactMap
2020-11-15T22:52:16.3686190Z [576/624] Compiling Node StructuredDataWrapper+Convenience.swift
2020-11-15T22:52:16.3688850Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/StructuredDataWrapper/StructuredDataWrapper+PathIndexable.swift:30:34: warning: 'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value
2020-11-15T22:52:16.3690300Z         let context = array.lazy.flatMap { $0.context } .first
2020-11-15T22:52:16.3690640Z                                  ^
2020-11-15T22:52:16.3692290Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/StructuredDataWrapper/StructuredDataWrapper+PathIndexable.swift:30:34: note: use 'compactMap(_:)' instead
2020-11-15T22:52:16.3693490Z         let context = array.lazy.flatMap { $0.context } .first
2020-11-15T22:52:16.3693830Z                                  ^~~~~~~
2020-11-15T22:52:16.3694060Z                                  compactMap
2020-11-15T22:52:16.3694860Z [577/624] Compiling Node StructuredDataWrapper+Equatable.swift
2020-11-15T22:52:16.3697380Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/StructuredDataWrapper/StructuredDataWrapper+PathIndexable.swift:30:34: warning: 'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value
2020-11-15T22:52:16.3699230Z         let context = array.lazy.flatMap { $0.context } .first
2020-11-15T22:52:16.3700200Z                                  ^
2020-11-15T22:52:16.3701870Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/StructuredDataWrapper/StructuredDataWrapper+PathIndexable.swift:30:34: note: use 'compactMap(_:)' instead
2020-11-15T22:52:16.3703070Z         let context = array.lazy.flatMap { $0.context } .first
2020-11-15T22:52:16.3703420Z                                  ^~~~~~~
2020-11-15T22:52:16.3703650Z                                  compactMap
2020-11-15T22:52:16.3704220Z [578/624] Compiling Node StructuredDataWrapper+Literals.swift
2020-11-15T22:52:16.3706340Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/StructuredDataWrapper/StructuredDataWrapper+PathIndexable.swift:30:34: warning: 'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value
2020-11-15T22:52:16.3707750Z         let context = array.lazy.flatMap { $0.context } .first
2020-11-15T22:52:16.3708090Z                                  ^
2020-11-15T22:52:16.3709590Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/StructuredDataWrapper/StructuredDataWrapper+PathIndexable.swift:30:34: note: use 'compactMap(_:)' instead
2020-11-15T22:52:16.3711400Z         let context = array.lazy.flatMap { $0.context } .first
2020-11-15T22:52:16.3712150Z                                  ^~~~~~~
2020-11-15T22:52:16.3712380Z                                  compactMap
2020-11-15T22:52:16.3713810Z [579/624] Compiling Node StructuredDataWrapper+PathIndexable.swift
2020-11-15T22:52:16.3716870Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/StructuredDataWrapper/StructuredDataWrapper+PathIndexable.swift:30:34: warning: 'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value
2020-11-15T22:52:16.3718300Z         let context = array.lazy.flatMap { $0.context } .first
2020-11-15T22:52:16.3718640Z                                  ^
2020-11-15T22:52:16.3720160Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/StructuredDataWrapper/StructuredDataWrapper+PathIndexable.swift:30:34: note: use 'compactMap(_:)' instead
2020-11-15T22:52:16.3721660Z         let context = array.lazy.flatMap { $0.context } .first
2020-11-15T22:52:16.3722010Z                                  ^~~~~~~
2020-11-15T22:52:16.3722240Z                                  compactMap
2020-11-15T22:52:16.3722850Z [580/624] Compiling Node StructuredDataWrapper+Polymorphic.swift
2020-11-15T22:52:16.3725440Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/StructuredDataWrapper/StructuredDataWrapper+PathIndexable.swift:30:34: warning: 'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value
2020-11-15T22:52:16.3727230Z         let context = array.lazy.flatMap { $0.context } .first
2020-11-15T22:52:16.3727610Z                                  ^
2020-11-15T22:52:16.3729180Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/StructuredDataWrapper/StructuredDataWrapper+PathIndexable.swift:30:34: note: use 'compactMap(_:)' instead
2020-11-15T22:52:16.3730370Z         let context = array.lazy.flatMap { $0.context } .first
2020-11-15T22:52:16.3730710Z                                  ^~~~~~~
2020-11-15T22:52:16.3730930Z                                  compactMap
2020-11-15T22:52:16.3731380Z [581/624] Compiling Node StructuredDataWrapper.swift
2020-11-15T22:52:16.3733580Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/StructuredDataWrapper/StructuredDataWrapper+PathIndexable.swift:30:34: warning: 'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value
2020-11-15T22:52:16.3734990Z         let context = array.lazy.flatMap { $0.context } .first
2020-11-15T22:52:16.3735330Z                                  ^
2020-11-15T22:52:16.3736820Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/StructuredDataWrapper/StructuredDataWrapper+PathIndexable.swift:30:34: note: use 'compactMap(_:)' instead
2020-11-15T22:52:16.3738420Z         let context = array.lazy.flatMap { $0.context } .first
2020-11-15T22:52:16.3738780Z                                  ^~~~~~~
2020-11-15T22:52:16.3739000Z                                  compactMap
2020-11-15T22:52:16.3739310Z [582/624] Compiling Node Errors.swift
2020-11-15T22:52:16.3741200Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/StructuredDataWrapper/StructuredDataWrapper+PathIndexable.swift:30:34: warning: 'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value
2020-11-15T22:52:16.3742610Z         let context = array.lazy.flatMap { $0.context } .first
2020-11-15T22:52:16.3742950Z                                  ^
2020-11-15T22:52:16.3744450Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/StructuredDataWrapper/StructuredDataWrapper+PathIndexable.swift:30:34: note: use 'compactMap(_:)' instead
2020-11-15T22:52:16.3745640Z         let context = array.lazy.flatMap { $0.context } .first
2020-11-15T22:52:16.3745990Z                                  ^~~~~~~
2020-11-15T22:52:16.3746210Z                                  compactMap
2020-11-15T22:52:16.3746510Z [583/624] Compiling Node Exports.swift
2020-11-15T22:52:16.3748530Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/StructuredDataWrapper/StructuredDataWrapper+PathIndexable.swift:30:34: warning: 'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value
2020-11-15T22:52:16.3750050Z         let context = array.lazy.flatMap { $0.context } .first
2020-11-15T22:52:16.3750390Z                                  ^
2020-11-15T22:52:16.3751910Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/StructuredDataWrapper/StructuredDataWrapper+PathIndexable.swift:30:34: note: use 'compactMap(_:)' instead
2020-11-15T22:52:16.3753110Z         let context = array.lazy.flatMap { $0.context } .first
2020-11-15T22:52:16.3753450Z                                  ^~~~~~~
2020-11-15T22:52:16.3753680Z                                  compactMap
2020-11-15T22:52:16.3754010Z [584/624] Compiling Node Identifier.swift
2020-11-15T22:52:16.3755870Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/StructuredDataWrapper/StructuredDataWrapper+PathIndexable.swift:30:34: warning: 'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value
2020-11-15T22:52:16.3757280Z         let context = array.lazy.flatMap { $0.context } .first
2020-11-15T22:52:16.3757620Z                                  ^
2020-11-15T22:52:16.3759360Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/node/Sources/Node/StructuredDataWrapper/StructuredDataWrapper+PathIndexable.swift:30:34: note: use 'compactMap(_:)' instead
2020-11-15T22:52:16.3760580Z         let context = array.lazy.flatMap { $0.context } .first
2020-11-15T22:52:16.3760920Z                                  ^~~~~~~
2020-11-15T22:52:16.3761150Z                                  compactMap
2020-11-15T22:52:16.3828520Z [585/624] Merging module ApplicativeRouter
2020-11-15T22:52:16.5493250Z [586/624] Compiling Node Optional+Convertible.swift
2020-11-15T22:52:16.5593600Z [587/624] Compiling Node Set+Convertible.swift
2020-11-15T22:52:16.5694890Z [588/624] Compiling Node Number.swift
2020-11-15T22:52:16.5795230Z [589/624] Compiling Node StructuredData+Equatable.swift
2020-11-15T22:52:16.5896830Z [590/624] Compiling Node StructuredData+Init.swift
2020-11-15T22:52:16.5897690Z [591/624] Compiling Node StructuredData+PathIndexable.swift
2020-11-15T22:52:16.5998580Z [592/624] Compiling Node StructuredData+Polymorphic.swift
2020-11-15T22:52:16.5999660Z [593/624] Compiling Node StructuredData.swift
2020-11-15T22:52:16.6000570Z [594/624] Compiling Node StructuredDataWrapper+Cases.swift
2020-11-15T22:52:16.7700070Z [595/625] Merging module Node
2020-11-15T22:52:17.0700130Z [596/637] Compiling PostgreSQL Context.swift
2020-11-15T22:52:17.0800870Z [597/637] Compiling PostgreSQL Database.swift
2020-11-15T22:52:17.2257350Z [598/637] Compiling PostgreSQL ConnectionInfo.swift
2020-11-15T22:52:17.3706650Z [601/637] Compiling PostgreSQL BinaryUtils.swift
2020-11-15T22:52:17.3728270Z [602/637] Compiling PostgreSQL Bind+Node.swift
2020-11-15T22:52:17.3729090Z [603/637] Compiling PostgreSQL Bind.swift
2020-11-15T22:52:17.6070310Z [604/638] Merging module NIOHTTP1
2020-11-15T22:52:17.8146730Z [605/644] Compiling NIOHTTPCompression HTTPRequestDecompressor.swift
2020-11-15T22:52:17.8207180Z [606/644] Compiling NIOHTTPCompression HTTPResponseCompressor.swift
2020-11-15T22:52:17.8307540Z [607/644] Compiling NIOHTTPCompression HTTPResponseDecompressor.swift
2020-11-15T22:52:18.1759780Z [608/644] Compiling PostgreSQL Error.swift
2020-11-15T22:52:18.1760250Z [609/644] Compiling PostgreSQL Exports.swift
2020-11-15T22:52:18.1760660Z [610/644] Compiling PostgreSQL Result.swift
2020-11-15T22:52:18.4134970Z [612/644] Compiling NIOHTTPCompression HTTPRequestCompressor.swift
2020-11-15T22:52:18.6068970Z [615/644] Compiling NIOHTTPCompression HTTPCompression.swift
2020-11-15T22:52:18.6069770Z [616/644] Compiling NIOHTTPCompression HTTPDecompression.swift
2020-11-15T22:52:18.6427660Z [617/645] Compiling Models 0119-ParsersRecap.swift
2020-11-15T22:52:18.6432800Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0112-DesigningDependencies.swift:4:55: warning: expression took 217ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6462640Z   public static let ep112_designingDependencies_pt3 = Episode(
2020-11-15T22:52:18.6463410Z                                                       ^~~~~~~~
2020-11-15T22:52:18.6465150Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/AllEpisodes.swift:2:35: warning: expression took 2562ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6466160Z   public static let all: [Self] = [
2020-11-15T22:52:18.6466640Z                                   ^
2020-11-15T22:52:18.6467720Z [618/645] Compiling Models 0120-ParsersRecap.swift
2020-11-15T22:52:18.6469360Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0112-DesigningDependencies.swift:4:55: warning: expression took 217ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6470610Z   public static let ep112_designingDependencies_pt3 = Episode(
2020-11-15T22:52:18.6471250Z                                                       ^~~~~~~~
2020-11-15T22:52:18.6472590Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/AllEpisodes.swift:2:35: warning: expression took 2562ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6473580Z   public static let all: [Self] = [
2020-11-15T22:52:18.6474050Z                                   ^
2020-11-15T22:52:18.6474990Z [619/645] Compiling Models 0121-ParsersRecap.swift
2020-11-15T22:52:18.6477350Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0112-DesigningDependencies.swift:4:55: warning: expression took 217ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6478650Z   public static let ep112_designingDependencies_pt3 = Episode(
2020-11-15T22:52:18.6479280Z                                                       ^~~~~~~~
2020-11-15T22:52:18.6480640Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/AllEpisodes.swift:2:35: warning: expression took 2562ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6481620Z   public static let all: [Self] = [
2020-11-15T22:52:18.6482540Z                                   ^
2020-11-15T22:52:18.6483510Z [620/645] Compiling Models 0122-ParsersRecap.swift
2020-11-15T22:52:18.6485140Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0112-DesigningDependencies.swift:4:55: warning: expression took 217ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6486390Z   public static let ep112_designingDependencies_pt3 = Episode(
2020-11-15T22:52:18.6487030Z                                                       ^~~~~~~~
2020-11-15T22:52:18.6488340Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/AllEpisodes.swift:2:35: warning: expression took 2562ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6489330Z   public static let all: [Self] = [
2020-11-15T22:52:18.6489800Z                                   ^
2020-11-15T22:52:18.6490700Z [621/645] Compiling Models 0123-FluentZip.swift
2020-11-15T22:52:18.6492310Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0112-DesigningDependencies.swift:4:55: warning: expression took 217ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6493550Z   public static let ep112_designingDependencies_pt3 = Episode(
2020-11-15T22:52:18.6494180Z                                                       ^~~~~~~~
2020-11-15T22:52:18.6495500Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/AllEpisodes.swift:2:35: warning: expression took 2562ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6496480Z   public static let all: [Self] = [
2020-11-15T22:52:18.6496950Z                                   ^
2020-11-15T22:52:18.6497950Z [622/645] Compiling Models 0124-GeneralizedParsing.swift
2020-11-15T22:52:18.6499630Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0112-DesigningDependencies.swift:4:55: warning: expression took 217ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6500860Z   public static let ep112_designingDependencies_pt3 = Episode(
2020-11-15T22:52:18.6501490Z                                                       ^~~~~~~~
2020-11-15T22:52:18.6502820Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/AllEpisodes.swift:2:35: warning: expression took 2562ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6503800Z   public static let all: [Self] = [
2020-11-15T22:52:18.6504260Z                                   ^
2020-11-15T22:52:18.6505260Z [623/645] Compiling Models 0125-GeneralizedParsing.swift
2020-11-15T22:52:18.6506950Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0112-DesigningDependencies.swift:4:55: warning: expression took 217ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6508350Z   public static let ep112_designingDependencies_pt3 = Episode(
2020-11-15T22:52:18.6508990Z                                                       ^~~~~~~~
2020-11-15T22:52:18.6510310Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/AllEpisodes.swift:2:35: warning: expression took 2562ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6511300Z   public static let all: [Self] = [
2020-11-15T22:52:18.6511790Z                                   ^
2020-11-15T22:52:18.6512340Z [624/645] Compiling Models AllEpisodes.swift
2020-11-15T22:52:18.6513900Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0112-DesigningDependencies.swift:4:55: warning: expression took 217ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6515440Z   public static let ep112_designingDependencies_pt3 = Episode(
2020-11-15T22:52:18.6516160Z                                                       ^~~~~~~~
2020-11-15T22:52:18.6517520Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/AllEpisodes.swift:2:35: warning: expression took 2562ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6518500Z   public static let all: [Self] = [
2020-11-15T22:52:18.6518970Z                                   ^
2020-11-15T22:52:18.6519520Z [625/645] Compiling Models References.swift
2020-11-15T22:52:18.6521170Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0112-DesigningDependencies.swift:4:55: warning: expression took 217ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6523100Z   public static let ep112_designingDependencies_pt3 = Episode(
2020-11-15T22:52:18.6527610Z                                                       ^~~~~~~~
2020-11-15T22:52:18.6529050Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/AllEpisodes.swift:2:35: warning: expression took 2562ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6529840Z   public static let all: [Self] = [
2020-11-15T22:52:18.6534570Z                                   ^
2020-11-15T22:52:18.6536130Z [626/645] Compiling Models XYZW-TODO.swift
2020-11-15T22:52:18.6537610Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0112-DesigningDependencies.swift:4:55: warning: expression took 217ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6538570Z   public static let ep112_designingDependencies_pt3 = Episode(
2020-11-15T22:52:18.6538970Z                                                       ^~~~~~~~
2020-11-15T22:52:18.6540070Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/AllEpisodes.swift:2:35: warning: expression took 2562ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6540770Z   public static let all: [Self] = [
2020-11-15T22:52:18.6541010Z                                   ^
2020-11-15T22:52:18.6541370Z [627/645] Compiling Models FeedRequestEvent.swift
2020-11-15T22:52:18.6542720Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0112-DesigningDependencies.swift:4:55: warning: expression took 217ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6543670Z   public static let ep112_designingDependencies_pt3 = Episode(
2020-11-15T22:52:18.6544060Z                                                       ^~~~~~~~
2020-11-15T22:52:18.6545110Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/AllEpisodes.swift:2:35: warning: expression took 2562ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6545800Z   public static let all: [Self] = [
2020-11-15T22:52:18.6546050Z                                   ^
2020-11-15T22:52:18.6546460Z [628/645] Compiling Models MailgunForwardPayload.swift
2020-11-15T22:52:18.6555840Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0112-DesigningDependencies.swift:4:55: warning: expression took 217ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6556840Z   public static let ep112_designingDependencies_pt3 = Episode(
2020-11-15T22:52:18.6557240Z                                                       ^~~~~~~~
2020-11-15T22:52:18.6558320Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/AllEpisodes.swift:2:35: warning: expression took 2562ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6559010Z   public static let all: [Self] = [
2020-11-15T22:52:18.6559250Z                                   ^
2020-11-15T22:52:18.6559520Z [629/645] Compiling Models Models.swift
2020-11-15T22:52:18.6560780Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0112-DesigningDependencies.swift:4:55: warning: expression took 217ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6561740Z   public static let ep112_designingDependencies_pt3 = Episode(
2020-11-15T22:52:18.6562140Z                                                       ^~~~~~~~
2020-11-15T22:52:18.6563630Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/AllEpisodes.swift:2:35: warning: expression took 2562ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6564360Z   public static let all: [Self] = [
2020-11-15T22:52:18.6564600Z                                   ^
2020-11-15T22:52:18.6564990Z [630/645] Compiling Models NewBlogPostFormData.swift
2020-11-15T22:52:18.6566400Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0112-DesigningDependencies.swift:4:55: warning: expression took 217ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6567340Z   public static let ep112_designingDependencies_pt3 = Episode(
2020-11-15T22:52:18.6567730Z                                                       ^~~~~~~~
2020-11-15T22:52:18.6569070Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/AllEpisodes.swift:2:35: warning: expression took 2562ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6569760Z   public static let all: [Self] = [
2020-11-15T22:52:18.6570000Z                                   ^
2020-11-15T22:52:18.6570280Z [631/645] Compiling Models Pricing.swift
2020-11-15T22:52:18.6571550Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0112-DesigningDependencies.swift:4:55: warning: expression took 217ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6572490Z   public static let ep112_designingDependencies_pt3 = Episode(
2020-11-15T22:52:18.6572890Z                                                       ^~~~~~~~
2020-11-15T22:52:18.6573940Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/AllEpisodes.swift:2:35: warning: expression took 2562ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6574630Z   public static let all: [Self] = [
2020-11-15T22:52:18.6574870Z                                   ^
2020-11-15T22:52:18.6575180Z [632/645] Compiling Models ProfileData.swift
2020-11-15T22:52:18.6576460Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0112-DesigningDependencies.swift:4:55: warning: expression took 217ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6577520Z   public static let ep112_designingDependencies_pt3 = Episode(
2020-11-15T22:52:18.6578030Z                                                       ^~~~~~~~
2020-11-15T22:52:18.6579110Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/AllEpisodes.swift:2:35: warning: expression took 2562ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6579800Z   public static let all: [Self] = [
2020-11-15T22:52:18.6580050Z                                   ^
2020-11-15T22:52:18.6580510Z [633/645] Compiling Models SubscribeConfirmationData.swift
2020-11-15T22:52:18.6581950Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0112-DesigningDependencies.swift:4:55: warning: expression took 217ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6582910Z   public static let ep112_designingDependencies_pt3 = Episode(
2020-11-15T22:52:18.6583310Z                                                       ^~~~~~~~
2020-11-15T22:52:18.6584350Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/AllEpisodes.swift:2:35: warning: expression took 2562ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6585040Z   public static let all: [Self] = [
2020-11-15T22:52:18.6585280Z                                   ^
2020-11-15T22:52:18.6585610Z [634/645] Compiling Models SubscribeData.swift
2020-11-15T22:52:18.6586920Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0112-DesigningDependencies.swift:4:55: warning: expression took 217ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6587870Z   public static let ep112_designingDependencies_pt3 = Episode(
2020-11-15T22:52:18.6588260Z                                                       ^~~~~~~~
2020-11-15T22:52:18.6589320Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/AllEpisodes.swift:2:35: warning: expression took 2562ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6590010Z   public static let all: [Self] = [
2020-11-15T22:52:18.6590250Z                                   ^
2020-11-15T22:52:18.6590590Z [635/645] Compiling Models SubscriberState.swift
2020-11-15T22:52:18.6592090Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0112-DesigningDependencies.swift:4:55: warning: expression took 217ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6593070Z   public static let ep112_designingDependencies_pt3 = Episode(
2020-11-15T22:52:18.6593470Z                                                       ^~~~~~~~
2020-11-15T22:52:18.6594550Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/AllEpisodes.swift:2:35: warning: expression took 2562ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6595240Z   public static let all: [Self] = [
2020-11-15T22:52:18.6595690Z                                   ^
2020-11-15T22:52:18.6596010Z [636/645] Compiling Models Subscription.swift
2020-11-15T22:52:18.6597340Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0112-DesigningDependencies.swift:4:55: warning: expression took 217ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6598290Z   public static let ep112_designingDependencies_pt3 = Episode(
2020-11-15T22:52:18.6598680Z                                                       ^~~~~~~~
2020-11-15T22:52:18.6599720Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/AllEpisodes.swift:2:35: warning: expression took 2562ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6600410Z   public static let all: [Self] = [
2020-11-15T22:52:18.6600660Z                                   ^
2020-11-15T22:52:18.6600960Z [637/645] Compiling Models TeamInvite.swift
2020-11-15T22:52:18.6602240Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0112-DesigningDependencies.swift:4:55: warning: expression took 217ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6603190Z   public static let ep112_designingDependencies_pt3 = Episode(
2020-11-15T22:52:18.6603590Z                                                       ^~~~~~~~
2020-11-15T22:52:18.6604650Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/AllEpisodes.swift:2:35: warning: expression took 2562ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6605330Z   public static let all: [Self] = [
2020-11-15T22:52:18.6605560Z                                   ^
2020-11-15T22:52:18.6605830Z [638/645] Compiling Models User.swift
2020-11-15T22:52:18.6607130Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/0112-DesigningDependencies.swift:4:55: warning: expression took 217ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6608080Z   public static let ep112_designingDependencies_pt3 = Episode(
2020-11-15T22:52:18.6608470Z                                                       ^~~~~~~~
2020-11-15T22:52:18.6609540Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Models/Episodes/AllEpisodes.swift:2:35: warning: expression took 2562ms to type-check (limit: 200ms)
2020-11-15T22:52:18.6610230Z   public static let all: [Self] = [
2020-11-15T22:52:18.6610480Z                                   ^
2020-11-15T22:52:18.7958510Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/postgresql/Sources/PostgreSQL/Bind/BinaryUtils.swift:7:60: warning: 'characters' is deprecated: Please use String directly
2020-11-15T22:52:18.7965940Z         return String(repeating: "0", count: 2 - hexString.characters.count) + hexString
2020-11-15T22:52:18.7966820Z                                                            ^
2020-11-15T22:52:18.7968340Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/postgresql/Sources/PostgreSQL/Bind/BinaryUtils.swift:12:60: warning: 'characters' is deprecated: Please use String directly
2020-11-15T22:52:18.7970110Z         return String(repeating: "0", count: 8 - bitString.characters.count) + bitString
2020-11-15T22:52:18.7970930Z                                                            ^
2020-11-15T22:52:18.7972410Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/postgresql/Sources/PostgreSQL/Bind/BinaryUtils.swift:193:83: warning: 'characters' is deprecated: Please use String directly
2020-11-15T22:52:18.7974630Z             return String(repeating: "0", count: Numeric.decDigits - stringDigits.characters.count) + stringDigits
2020-11-15T22:52:18.7975620Z                                                                                   ^
2020-11-15T22:52:18.7977410Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/postgresql/Sources/PostgreSQL/Bind/Bind.swift:17:23: warning: 'deallocate(capacity:)' is deprecated: Swift currently only supports freeing entire heap blocks, use deallocate() instead
2020-11-15T22:52:18.7978740Z                 bytes.deallocate(capacity: length)
2020-11-15T22:52:18.7979290Z                       ^
2020-11-15T22:52:18.7981090Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/postgresql/Sources/PostgreSQL/Bind/BinaryUtils.swift:7:60: warning: 'characters' is deprecated: Please use String directly
2020-11-15T22:52:18.7983450Z         return String(repeating: "0", count: 2 - hexString.characters.count) + hexString
2020-11-15T22:52:18.7984250Z                                                            ^
2020-11-15T22:52:18.7985740Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/postgresql/Sources/PostgreSQL/Bind/BinaryUtils.swift:12:60: warning: 'characters' is deprecated: Please use String directly
2020-11-15T22:52:18.7987520Z         return String(repeating: "0", count: 8 - bitString.characters.count) + bitString
2020-11-15T22:52:18.7988310Z                                                            ^
2020-11-15T22:52:18.7990010Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/postgresql/Sources/PostgreSQL/Bind/BinaryUtils.swift:193:83: warning: 'characters' is deprecated: Please use String directly
2020-11-15T22:52:18.7991940Z             return String(repeating: "0", count: Numeric.decDigits - stringDigits.characters.count) + stringDigits
2020-11-15T22:52:18.7992890Z                                                                                   ^
2020-11-15T22:52:18.7994560Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/postgresql/Sources/PostgreSQL/Bind/Bind.swift:17:23: warning: 'deallocate(capacity:)' is deprecated: Swift currently only supports freeing entire heap blocks, use deallocate() instead
2020-11-15T22:52:18.7996050Z                 bytes.deallocate(capacity: length)
2020-11-15T22:52:18.7996610Z                       ^
2020-11-15T22:52:18.7998080Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/postgresql/Sources/PostgreSQL/Bind/BinaryUtils.swift:7:60: warning: 'characters' is deprecated: Please use String directly
2020-11-15T22:52:18.7999830Z         return String(repeating: "0", count: 2 - hexString.characters.count) + hexString
2020-11-15T22:52:18.8000620Z                                                            ^
2020-11-15T22:52:18.8002110Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/postgresql/Sources/PostgreSQL/Bind/BinaryUtils.swift:12:60: warning: 'characters' is deprecated: Please use String directly
2020-11-15T22:52:18.8003860Z         return String(repeating: "0", count: 8 - bitString.characters.count) + bitString
2020-11-15T22:52:18.8004660Z                                                            ^
2020-11-15T22:52:18.8006140Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/postgresql/Sources/PostgreSQL/Bind/BinaryUtils.swift:193:83: warning: 'characters' is deprecated: Please use String directly
2020-11-15T22:52:18.8008050Z             return String(repeating: "0", count: Numeric.decDigits - stringDigits.characters.count) + stringDigits
2020-11-15T22:52:18.8009000Z                                                                                   ^
2020-11-15T22:52:18.8010660Z /Users/runner/work/pointfreeco/pointfreeco/.build/checkouts/postgresql/Sources/PostgreSQL/Bind/Bind.swift:17:23: warning: 'deallocate(capacity:)' is deprecated: Swift currently only supports freeing entire heap blocks, use deallocate() instead
2020-11-15T22:52:18.8012000Z                 bytes.deallocate(capacity: length)
2020-11-15T22:52:18.8012640Z                       ^
2020-11-15T22:52:18.8101250Z [642/647] Merging module NIOHTTPCompression
2020-11-15T22:52:19.2250490Z [643/655] Merging module Models
2020-11-15T22:52:19.2947050Z [644/655] Merging module PostgreSQL
2020-11-15T22:52:19.8815630Z [645/664] Compiling Database Database.swift
2020-11-15T22:52:19.8916620Z [646/664] Compiling Database DatabaseDecoder.swift
2020-11-15T22:52:20.0611980Z [647/664] Compiling ModelsTestSupport PricingMocks.swift
2020-11-15T22:52:20.1582180Z [648/664] Compiling ModelsTestSupport SubscribeDataMocks.swift
2020-11-15T22:52:20.5456950Z [651/664] Compiling ModelsTestSupport Mocks.swift
2020-11-15T22:52:20.8672550Z [652/665] Merging module ModelsTestSupport
2020-11-15T22:52:21.0324010Z [653/668] Compiling ModelsTests BlogPostTest.swift
2020-11-15T22:52:21.6310660Z [655/668] Compiling ModelsTests CollectionTests.swift
2020-11-15T22:52:21.6882290Z [656/668] Compiling ModelsTests EpisodeTests.swift
2020-11-15T22:52:21.9241420Z [659/669] Compiling HttpPipeline SignedCookies.swift
2020-11-15T22:52:21.9442430Z [660/669] Compiling HttpPipeline Status.swift
2020-11-15T22:52:22.1769340Z [661/669] Merging module ModelsTests
2020-11-15T22:52:22.3554590Z [664/670] Compiling HttpPipeline SharedMiddlewareTransformers.swift
2020-11-15T22:52:22.5171850Z [667/672] Merging module Syndication
2020-11-15T22:52:22.6302100Z [668/672] Merging module HttpPipeline
2020-11-15T22:52:22.7963880Z [669/683] Merging module Database
2020-11-15T22:52:23.0803820Z [670/685] Compiling Mailgun Client.swift
2020-11-15T22:52:23.3240570Z [672/687] Merging module HttpPipelineHtmlSupport
2020-11-15T22:52:23.3541850Z [673/688] Merging module ApplicativeRouterHttpPipelineSupport
2020-11-15T22:52:23.8399250Z [674/689] Compiling Mailgun Models.swift
2020-11-15T22:52:23.9541760Z [675/689] Compiling DatabaseTestSupport Mocks.swift
2020-11-15T22:52:24.0589600Z [676/690] Compiling PointFreeRouter GitHubRoutes.swift
2020-11-15T22:52:24.0691290Z [677/690] Compiling PointFreeRouter PartialIsoReflection.swift
2020-11-15T22:52:24.1780600Z [678/690] Merging module DatabaseTestSupport
2020-11-15T22:52:24.2997740Z [681/690] Compiling PointFreeRouter ApiRoutes.swift
2020-11-15T22:52:24.3324680Z [682/690] Compiling PointFreeRouter TwitterRoutes.swift
2020-11-15T22:52:24.3325510Z [683/690] Compiling PointFreeRouter Util.swift
2020-11-15T22:52:24.6289340Z [686/692] Merging module Mailgun
2020-11-15T22:52:24.8165410Z [687/692] Merging module HttpPipelineTestSupport
2020-11-15T22:52:25.2849200Z [688/692] Compiling PointFreeRouter PointFreeRouter.swift
2020-11-15T22:52:25.2859030Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFreeRouter/Routes.swift:138:32: warning: expression took 296ms to type-check (limit: 200ms)
2020-11-15T22:52:25.2860080Z let routers: [Router<Route>] = [
2020-11-15T22:52:25.2860620Z                                ^
2020-11-15T22:52:25.2861280Z [689/692] Compiling PointFreeRouter Routes.swift
2020-11-15T22:52:25.2862790Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFreeRouter/Routes.swift:138:32: warning: expression took 296ms to type-check (limit: 200ms)
2020-11-15T22:52:25.2863790Z let routers: [Router<Route>] = [
2020-11-15T22:52:25.2864270Z                                ^
2020-11-15T22:52:25.6881590Z [690/693] Merging module PointFreeRouter
2020-11-15T22:52:26.6244240Z [691/724] Compiling Views About.swift
2020-11-15T22:52:27.2255710Z [692/725] Merging module PointFreeRouterTests
2020-11-15T22:52:28.2902900Z [693/725] Compiling Views Privacy.swift
2020-11-15T22:52:28.2927610Z [694/725] Compiling Views StripeHtml.swift
2020-11-15T22:52:28.2928400Z [695/725] Compiling Views SubscriptionConfirmation.swift
2020-11-15T22:52:28.2934360Z [696/725] Compiling Views Svg.swift
2020-11-15T22:52:28.2934750Z [697/725] Compiling Views TODO.swift
2020-11-15T22:52:28.2935170Z [698/725] Compiling Views Testimonials.swift
2020-11-15T22:52:28.2935700Z [699/725] Compiling Views TranscriptBlockView.swift
2020-11-15T22:52:28.5136190Z [700/725] Compiling Views Footer.swift
2020-11-15T22:52:28.5136980Z [701/725] Compiling Views Home.swift
2020-11-15T22:52:28.5137400Z [702/725] Compiling Views InviteViews.swift
2020-11-15T22:52:28.5138380Z [703/725] Compiling Views Markdown.swift
2020-11-15T22:52:28.5138880Z [704/725] Compiling Views MinimalNavView.swift
2020-11-15T22:52:28.5139380Z [705/725] Compiling Views MountainNavView.swift
2020-11-15T22:52:28.5139870Z [706/725] Compiling Views PricingLanding.swift
2020-11-15T22:52:29.1286960Z [707/725] Compiling Views CollectionIndex.swift
2020-11-15T22:52:29.1287600Z [708/725] Compiling Views CollectionSection.swift
2020-11-15T22:52:29.1289640Z [709/725] Compiling Views CollectionShared.swift
2020-11-15T22:52:29.1290270Z [710/725] Compiling Views CollectionShow.swift
2020-11-15T22:52:29.1290710Z [711/725] Compiling Views Enterprise.swift
2020-11-15T22:52:29.1291620Z [712/725] Compiling Views EpisodePage.swift
2020-11-15T22:52:29.1292110Z [713/725] Compiling Views EpisodeVideoView.swift
2020-11-15T22:52:29.1292540Z [714/725] Compiling Views File.swift
2020-11-15T22:52:29.2125140Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Views/Account/Account.swift:551:11: warning: expression took 287ms to type-check (limit: 200ms)
2020-11-15T22:52:29.2126170Z   return .gridRow(
2020-11-15T22:52:29.2126410Z          ~^~~~~~~~
2020-11-15T22:52:29.2128470Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Views/Account/Account.swift:537:14: warning: global function 'subscriptionTeammateOverview' took 289ms to type-check (limit: 200ms)
2020-11-15T22:52:29.2133080Z private func subscriptionTeammateOverview(_ data: AccountData) -> Node {
2020-11-15T22:52:29.2134250Z              ^
2020-11-15T22:52:29.2134540Z [716/725] Compiling Views Account.swift
2020-11-15T22:52:29.2135760Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Views/Account/Account.swift:551:11: warning: expression took 287ms to type-check (limit: 200ms)
2020-11-15T22:52:29.2136410Z   return .gridRow(
2020-11-15T22:52:29.2136630Z          ~^~~~~~~~
2020-11-15T22:52:29.2137890Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Views/Account/Account.swift:537:14: warning: global function 'subscriptionTeammateOverview' took 289ms to type-check (limit: 200ms)
2020-11-15T22:52:29.2139390Z private func subscriptionTeammateOverview(_ data: AccountData) -> Node {
2020-11-15T22:52:29.2139900Z              ^
2020-11-15T22:52:29.2140230Z [717/725] Compiling Views Invoices.swift
2020-11-15T22:52:29.2141360Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Views/Account/Account.swift:551:11: warning: expression took 287ms to type-check (limit: 200ms)
2020-11-15T22:52:29.2141990Z   return .gridRow(
2020-11-15T22:52:29.2142210Z          ~^~~~~~~~
2020-11-15T22:52:29.2143440Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Views/Account/Account.swift:537:14: warning: global function 'subscriptionTeammateOverview' took 289ms to type-check (limit: 200ms)
2020-11-15T22:52:29.2144930Z private func subscriptionTeammateOverview(_ data: AccountData) -> Node {
2020-11-15T22:52:29.2145440Z              ^
2020-11-15T22:52:29.2145790Z [718/725] Compiling Views PaymentInfoViews.swift
2020-11-15T22:52:29.2147110Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Views/Account/Account.swift:551:11: warning: expression took 287ms to type-check (limit: 200ms)
2020-11-15T22:52:29.2147760Z   return .gridRow(
2020-11-15T22:52:29.2147980Z          ~^~~~~~~~
2020-11-15T22:52:29.2149680Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Views/Account/Account.swift:537:14: warning: global function 'subscriptionTeammateOverview' took 289ms to type-check (limit: 200ms)
2020-11-15T22:52:29.2151160Z private func subscriptionTeammateOverview(_ data: AccountData) -> Node {
2020-11-15T22:52:29.2151660Z              ^
2020-11-15T22:52:29.2152040Z [719/725] Compiling Views AdminEpisodeCredit.swift
2020-11-15T22:52:29.2153760Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Views/Account/Account.swift:551:11: warning: expression took 287ms to type-check (limit: 200ms)
2020-11-15T22:52:29.2154410Z   return .gridRow(
2020-11-15T22:52:29.2154620Z          ~^~~~~~~~
2020-11-15T22:52:29.2156660Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Views/Account/Account.swift:537:14: warning: global function 'subscriptionTeammateOverview' took 289ms to type-check (limit: 200ms)
2020-11-15T22:52:29.2158260Z private func subscriptionTeammateOverview(_ data: AccountData) -> Node {
2020-11-15T22:52:29.2158770Z              ^
2020-11-15T22:52:29.2159120Z [720/725] Compiling Views AdminFreeEpisode.swift
2020-11-15T22:52:29.2160310Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Views/Account/Account.swift:551:11: warning: expression took 287ms to type-check (limit: 200ms)
2020-11-15T22:52:29.2160930Z   return .gridRow(
2020-11-15T22:52:29.2163430Z          ~^~~~~~~~
2020-11-15T22:52:29.2164780Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Views/Account/Account.swift:537:14: warning: global function 'subscriptionTeammateOverview' took 289ms to type-check (limit: 200ms)
2020-11-15T22:52:29.2166570Z private func subscriptionTeammateOverview(_ data: AccountData) -> Node {
2020-11-15T22:52:29.2167630Z              ^
2020-11-15T22:52:29.2167970Z [721/725] Compiling Views BlogIndex.swift
2020-11-15T22:52:29.2169320Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Views/Account/Account.swift:551:11: warning: expression took 287ms to type-check (limit: 200ms)
2020-11-15T22:52:29.2169970Z   return .gridRow(
2020-11-15T22:52:29.2170180Z          ~^~~~~~~~
2020-11-15T22:52:29.2171480Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Views/Account/Account.swift:537:14: warning: global function 'subscriptionTeammateOverview' took 289ms to type-check (limit: 200ms)
2020-11-15T22:52:29.2172970Z private func subscriptionTeammateOverview(_ data: AccountData) -> Node {
2020-11-15T22:52:29.2173470Z              ^
2020-11-15T22:52:29.2173800Z [722/725] Compiling Views BlogPostShow.swift
2020-11-15T22:52:29.2174960Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Views/Account/Account.swift:551:11: warning: expression took 287ms to type-check (limit: 200ms)
2020-11-15T22:52:29.2175580Z   return .gridRow(
2020-11-15T22:52:29.2175800Z          ~^~~~~~~~
2020-11-15T22:52:29.2177030Z /Users/runner/work/pointfreeco/pointfreeco/Sources/Views/Account/Account.swift:537:14: warning: global function 'subscriptionTeammateOverview' took 289ms to type-check (limit: 200ms)
2020-11-15T22:52:29.2178520Z private func subscriptionTeammateOverview(_ data: AccountData) -> Node {
2020-11-15T22:52:29.2179020Z              ^
2020-11-15T22:52:29.4749720Z [723/726] Merging module Views
2020-11-15T22:52:35.4081890Z [724/796] Compiling PointFree ApiMiddleware.swift
2020-11-15T22:52:35.4084120Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Auth.swift:23:3: warning: expression took 406ms to type-check (limit: 200ms)
2020-11-15T22:52:35.4085170Z   <<< requireAccessToken
2020-11-15T22:52:35.4085720Z ~~^~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:35.4086840Z [725/796] Compiling PointFree AppleDeveloperMerchantIdDomainAssociation.swift
2020-11-15T22:52:35.4088740Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Auth.swift:23:3: warning: expression took 406ms to type-check (limit: 200ms)
2020-11-15T22:52:35.4089750Z   <<< requireAccessToken
2020-11-15T22:52:35.4090290Z ~~^~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:35.4090850Z [726/796] Compiling PointFree Assets.swift
2020-11-15T22:52:35.4092230Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Auth.swift:23:3: warning: expression took 406ms to type-check (limit: 200ms)
2020-11-15T22:52:35.4093210Z   <<< requireAccessToken
2020-11-15T22:52:35.4093750Z ~~^~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:35.4094300Z [727/796] Compiling PointFree AtomFeed.swift
2020-11-15T22:52:35.4095690Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Auth.swift:23:3: warning: expression took 406ms to type-check (limit: 200ms)
2020-11-15T22:52:35.4096680Z   <<< requireAccessToken
2020-11-15T22:52:35.4097180Z ~~^~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:35.4097680Z [728/796] Compiling PointFree Auth.swift
2020-11-15T22:52:35.4099010Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Auth.swift:23:3: warning: expression took 406ms to type-check (limit: 200ms)
2020-11-15T22:52:35.4100470Z   <<< requireAccessToken
2020-11-15T22:52:35.4101060Z ~~^~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:35.4101630Z [729/796] Compiling PointFree AllBlogPosts.swift
2020-11-15T22:52:35.4103040Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Auth.swift:23:3: warning: expression took 406ms to type-check (limit: 200ms)
2020-11-15T22:52:35.4103980Z   <<< requireAccessToken
2020-11-15T22:52:35.4104460Z ~~^~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:35.4110980Z [730/796] Compiling PointFree BlogAtomFeed.swift
2020-11-15T22:52:35.4112530Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Auth.swift:23:3: warning: expression took 406ms to type-check (limit: 200ms)
2020-11-15T22:52:35.4113760Z   <<< requireAccessToken
2020-11-15T22:52:35.4114250Z ~~^~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:35.4114920Z [731/796] Compiling PointFree BlogMiddleware.swift
2020-11-15T22:52:35.4116380Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Auth.swift:23:3: warning: expression took 406ms to type-check (limit: 200ms)
2020-11-15T22:52:35.4117320Z   <<< requireAccessToken
2020-11-15T22:52:35.4117810Z ~~^~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:35.4118370Z [732/796] Compiling PointFree BlogPostIndex.swift
2020-11-15T22:52:35.4119770Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Auth.swift:23:3: warning: expression took 406ms to type-check (limit: 200ms)
2020-11-15T22:52:35.4120710Z   <<< requireAccessToken
2020-11-15T22:52:35.4121210Z ~~^~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:35.4121770Z [733/796] Compiling PointFree BlogPostShow.swift
2020-11-15T22:52:35.4123150Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Auth.swift:23:3: warning: expression took 406ms to type-check (limit: 200ms)
2020-11-15T22:52:35.4124100Z   <<< requireAccessToken
2020-11-15T22:52:35.4124590Z ~~^~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:35.4125120Z [734/796] Compiling PointFree Bootstrap.swift
2020-11-15T22:52:35.4126490Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Auth.swift:23:3: warning: expression took 406ms to type-check (limit: 200ms)
2020-11-15T22:52:35.4127420Z   <<< requireAccessToken
2020-11-15T22:52:35.4127910Z ~~^~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:35.4128500Z [735/796] Compiling PointFree CollectionIndex.swift
2020-11-15T22:52:35.4129910Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Auth.swift:23:3: warning: expression took 406ms to type-check (limit: 200ms)
2020-11-15T22:52:35.4130850Z   <<< requireAccessToken
2020-11-15T22:52:35.4131330Z ~~^~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:35.4131930Z [736/796] Compiling PointFree CollectionSection.swift
2020-11-15T22:52:35.4133360Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Auth.swift:23:3: warning: expression took 406ms to type-check (limit: 200ms)
2020-11-15T22:52:35.4134300Z   <<< requireAccessToken
2020-11-15T22:52:35.4134790Z ~~^~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:35.4135380Z [737/796] Compiling PointFree CollectionShow.swift
2020-11-15T22:52:35.4136780Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Auth.swift:23:3: warning: expression took 406ms to type-check (limit: 200ms)
2020-11-15T22:52:35.4137800Z   <<< requireAccessToken
2020-11-15T22:52:35.4138290Z ~~^~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:35.4138800Z [738/796] Compiling PointFree Debug.swift
2020-11-15T22:52:35.4140130Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Auth.swift:23:3: warning: expression took 406ms to type-check (limit: 200ms)
2020-11-15T22:52:35.4141060Z   <<< requireAccessToken
2020-11-15T22:52:35.4141550Z ~~^~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:35.4142130Z [739/796] Compiling PointFree AdminEmailReport.swift
2020-11-15T22:52:35.4143590Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Auth.swift:23:3: warning: expression took 406ms to type-check (limit: 200ms)
2020-11-15T22:52:35.4144520Z   <<< requireAccessToken
2020-11-15T22:52:35.4145010Z ~~^~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:35.4145690Z [740/796] Compiling PointFree ChangeEmailConfirmation.swift
2020-11-15T22:52:35.4147530Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Auth.swift:23:3: warning: expression took 406ms to type-check (limit: 200ms)
2020-11-15T22:52:35.4148510Z   <<< requireAccessToken
2020-11-15T22:52:35.4149010Z ~~^~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:35.4149570Z [741/796] Compiling PointFree EmailLayouts.swift
2020-11-15T22:52:35.4150970Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Auth.swift:23:3: warning: expression took 406ms to type-check (limit: 200ms)
2020-11-15T22:52:35.4151900Z   <<< requireAccessToken
2020-11-15T22:52:35.4152390Z ~~^~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:36.2881240Z [742/796] Compiling PointFree FreeEpisodeEmail.swift
2020-11-15T22:52:36.2884740Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Episode/Show.swift:19:5: warning: expression took 230ms to type-check (limit: 200ms)
2020-11-15T22:52:36.2885420Z     <| writeStatus(.ok)
2020-11-15T22:52:36.2885650Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:36.2886000Z [743/796] Compiling PointFree InviteEmail.swift
2020-11-15T22:52:36.2887500Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Episode/Show.swift:19:5: warning: expression took 230ms to type-check (limit: 200ms)
2020-11-15T22:52:36.2896200Z     <| writeStatus(.ok)
2020-11-15T22:52:36.2896690Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:36.2897160Z [744/796] Compiling PointFree NewBlogPostEmail.swift
2020-11-15T22:52:36.2899840Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Episode/Show.swift:19:5: warning: expression took 230ms to type-check (limit: 200ms)
2020-11-15T22:52:36.2900510Z     <| writeStatus(.ok)
2020-11-15T22:52:36.2900800Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:36.2901170Z [745/796] Compiling PointFree NewEpisodeEmail.swift
2020-11-15T22:52:36.2902450Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Episode/Show.swift:19:5: warning: expression took 230ms to type-check (limit: 200ms)
2020-11-15T22:52:36.2903090Z     <| writeStatus(.ok)
2020-11-15T22:52:36.2903330Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:36.2903670Z [746/796] Compiling PointFree ReferrerEmail.swift
2020-11-15T22:52:36.2904850Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Episode/Show.swift:19:5: warning: expression took 230ms to type-check (limit: 200ms)
2020-11-15T22:52:36.2905470Z     <| writeStatus(.ok)
2020-11-15T22:52:36.2905700Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:36.2906080Z [747/796] Compiling PointFree RegistrationEmail.swift
2020-11-15T22:52:36.2907280Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Episode/Show.swift:19:5: warning: expression took 230ms to type-check (limit: 200ms)
2020-11-15T22:52:36.2907920Z     <| writeStatus(.ok)
2020-11-15T22:52:36.2908150Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:36.2908460Z [748/796] Compiling PointFree SendEmail.swift
2020-11-15T22:52:36.2909590Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Episode/Show.swift:19:5: warning: expression took 230ms to type-check (limit: 200ms)
2020-11-15T22:52:36.2910230Z     <| writeStatus(.ok)
2020-11-15T22:52:36.2910450Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:36.2910880Z [749/796] Compiling PointFree SharedEmailComponents.swift
2020-11-15T22:52:36.2912120Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Episode/Show.swift:19:5: warning: expression took 230ms to type-check (limit: 200ms)
2020-11-15T22:52:36.2912750Z     <| writeStatus(.ok)
2020-11-15T22:52:36.2912980Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:36.2913300Z [750/796] Compiling PointFree TeamEmails.swift
2020-11-15T22:52:36.2914430Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Episode/Show.swift:19:5: warning: expression took 230ms to type-check (limit: 200ms)
2020-11-15T22:52:36.2915070Z     <| writeStatus(.ok)
2020-11-15T22:52:36.2915280Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:36.2915670Z [751/796] Compiling PointFree Enterprise.swift
2020-11-15T22:52:36.2917200Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Episode/Show.swift:19:5: warning: expression took 230ms to type-check (limit: 200ms)
2020-11-15T22:52:36.2917870Z     <| writeStatus(.ok)
2020-11-15T22:52:36.2918090Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:36.2918390Z [752/796] Compiling PointFree EnvVars.swift
2020-11-15T22:52:36.2919550Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Episode/Show.swift:19:5: warning: expression took 230ms to type-check (limit: 200ms)
2020-11-15T22:52:36.2920180Z     <| writeStatus(.ok)
2020-11-15T22:52:36.2920410Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:36.2920740Z [753/796] Compiling PointFree Environment.swift
2020-11-15T22:52:36.2921860Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Episode/Show.swift:19:5: warning: expression took 230ms to type-check (limit: 200ms)
2020-11-15T22:52:36.2922700Z     <| writeStatus(.ok)
2020-11-15T22:52:36.2922930Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:36.2923230Z [754/796] Compiling PointFree Episode.swift
2020-11-15T22:52:36.2924380Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Episode/Show.swift:19:5: warning: expression took 230ms to type-check (limit: 200ms)
2020-11-15T22:52:36.2925010Z     <| writeStatus(.ok)
2020-11-15T22:52:36.2925240Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:36.2925510Z [755/796] Compiling PointFree Show.swift
2020-11-15T22:52:36.2926590Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Episode/Show.swift:19:5: warning: expression took 230ms to type-check (limit: 200ms)
2020-11-15T22:52:36.2927420Z     <| writeStatus(.ok)
2020-11-15T22:52:36.2927650Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:36.2927980Z [756/796] Compiling PointFree FeatureFlags.swift
2020-11-15T22:52:36.2929170Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Episode/Show.swift:19:5: warning: expression took 230ms to type-check (limit: 200ms)
2020-11-15T22:52:36.2929810Z     <| writeStatus(.ok)
2020-11-15T22:52:36.2930040Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:36.2930400Z [757/796] Compiling PointFree GoogleAnalytics.swift
2020-11-15T22:52:36.2931590Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Episode/Show.swift:19:5: warning: expression took 230ms to type-check (limit: 200ms)
2020-11-15T22:52:36.2932210Z     <| writeStatus(.ok)
2020-11-15T22:52:36.2932440Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:36.2932710Z [758/796] Compiling PointFree Home.swift
2020-11-15T22:52:36.2933800Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Episode/Show.swift:19:5: warning: expression took 230ms to type-check (limit: 200ms)
2020-11-15T22:52:36.2934430Z     <| writeStatus(.ok)
2020-11-15T22:52:36.2934660Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:40.2042370Z [759/796] Compiling PointFree About.swift
2020-11-15T22:52:40.2044440Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/AccountMiddleware.swift:11:6: warning: global function 'accountMiddleware(conn:)' took 747ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2045720Z func accountMiddleware(conn: Conn<StatusLineOpen, Tuple4<Models.Subscription?, User?, SubscriberState, Account>>)
2020-11-15T22:52:40.2046350Z      ^
2020-11-15T22:52:40.2047440Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: closure took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2048510Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2048830Z            ^
2020-11-15T22:52:40.2049830Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: expression took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2050880Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2051190Z            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:40.2052310Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:116:14: warning: global function 'fetchSeatsTaken' took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2053100Z private func fetchSeatsTaken<A>(
2020-11-15T22:52:40.2053380Z              ^
2020-11-15T22:52:40.2054140Z [760/796] Compiling PointFree Account.swift
2020-11-15T22:52:40.2055590Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/AccountMiddleware.swift:11:6: warning: global function 'accountMiddleware(conn:)' took 747ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2056880Z func accountMiddleware(conn: Conn<StatusLineOpen, Tuple4<Models.Subscription?, User?, SubscriberState, Account>>)
2020-11-15T22:52:40.2057490Z      ^
2020-11-15T22:52:40.2058500Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: closure took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2059530Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2060060Z            ^
2020-11-15T22:52:40.2061100Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: expression took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2062150Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2062480Z            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:40.2063590Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:116:14: warning: global function 'fetchSeatsTaken' took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2064380Z private func fetchSeatsTaken<A>(
2020-11-15T22:52:40.2064660Z              ^
2020-11-15T22:52:40.2065140Z [761/796] Compiling PointFree AccountMiddleware.swift
2020-11-15T22:52:40.2066610Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/AccountMiddleware.swift:11:6: warning: global function 'accountMiddleware(conn:)' took 747ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2067860Z func accountMiddleware(conn: Conn<StatusLineOpen, Tuple4<Models.Subscription?, User?, SubscriberState, Account>>)
2020-11-15T22:52:40.2068470Z      ^
2020-11-15T22:52:40.2069460Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: closure took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2070500Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2070810Z            ^
2020-11-15T22:52:40.2071810Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: expression took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2072850Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2073160Z            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:40.2074260Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:116:14: warning: global function 'fetchSeatsTaken' took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2075060Z private func fetchSeatsTaken<A>(
2020-11-15T22:52:40.2075350Z              ^
2020-11-15T22:52:40.2075640Z [762/796] Compiling PointFree Cancel.swift
2020-11-15T22:52:40.2077080Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/AccountMiddleware.swift:11:6: warning: global function 'accountMiddleware(conn:)' took 747ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2078320Z func accountMiddleware(conn: Conn<StatusLineOpen, Tuple4<Models.Subscription?, User?, SubscriberState, Account>>)
2020-11-15T22:52:40.2078930Z      ^
2020-11-15T22:52:40.2079950Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: closure took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2080980Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2081280Z            ^
2020-11-15T22:52:40.2082270Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: expression took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2083320Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2083650Z            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:40.2084980Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:116:14: warning: global function 'fetchSeatsTaken' took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2085800Z private func fetchSeatsTaken<A>(
2020-11-15T22:52:40.2086080Z              ^
2020-11-15T22:52:40.2086380Z [763/796] Compiling PointFree Change.swift
2020-11-15T22:52:40.2087770Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/AccountMiddleware.swift:11:6: warning: global function 'accountMiddleware(conn:)' took 747ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2089010Z func accountMiddleware(conn: Conn<StatusLineOpen, Tuple4<Models.Subscription?, User?, SubscriberState, Account>>)
2020-11-15T22:52:40.2089610Z      ^
2020-11-15T22:52:40.2090590Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: closure took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2091850Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2092160Z            ^
2020-11-15T22:52:40.2093170Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: expression took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2094210Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2094540Z            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:40.2095640Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:116:14: warning: global function 'fetchSeatsTaken' took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2096430Z private func fetchSeatsTaken<A>(
2020-11-15T22:52:40.2096700Z              ^
2020-11-15T22:52:40.2096990Z [764/796] Compiling PointFree Invite.swift
2020-11-15T22:52:40.2098340Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/AccountMiddleware.swift:11:6: warning: global function 'accountMiddleware(conn:)' took 747ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2099590Z func accountMiddleware(conn: Conn<StatusLineOpen, Tuple4<Models.Subscription?, User?, SubscriberState, Account>>)
2020-11-15T22:52:40.2100200Z      ^
2020-11-15T22:52:40.2101200Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: closure took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2102230Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2102550Z            ^
2020-11-15T22:52:40.2103540Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: expression took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2104590Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2104900Z            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:40.2106010Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:116:14: warning: global function 'fetchSeatsTaken' took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2106800Z private func fetchSeatsTaken<A>(
2020-11-15T22:52:40.2107180Z              ^
2020-11-15T22:52:40.2107480Z [765/796] Compiling PointFree Invoices.swift
2020-11-15T22:52:40.2108880Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/AccountMiddleware.swift:11:6: warning: global function 'accountMiddleware(conn:)' took 747ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2110120Z func accountMiddleware(conn: Conn<StatusLineOpen, Tuple4<Models.Subscription?, User?, SubscriberState, Account>>)
2020-11-15T22:52:40.2110730Z      ^
2020-11-15T22:52:40.2111720Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: closure took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2113320Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2113630Z            ^
2020-11-15T22:52:40.2114630Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: expression took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2115680Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2116550Z            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:40.2117760Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:116:14: warning: global function 'fetchSeatsTaken' took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2118550Z private func fetchSeatsTaken<A>(
2020-11-15T22:52:40.2118830Z              ^
2020-11-15T22:52:40.2119160Z [766/796] Compiling PointFree PaymentInfo.swift
2020-11-15T22:52:40.2120560Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/AccountMiddleware.swift:11:6: warning: global function 'accountMiddleware(conn:)' took 747ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2121800Z func accountMiddleware(conn: Conn<StatusLineOpen, Tuple4<Models.Subscription?, User?, SubscriberState, Account>>)
2020-11-15T22:52:40.2122590Z      ^
2020-11-15T22:52:40.2123610Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: closure took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2124660Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2124970Z            ^
2020-11-15T22:52:40.2125970Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: expression took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2127010Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2127340Z            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:40.2128440Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:116:14: warning: global function 'fetchSeatsTaken' took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2129230Z private func fetchSeatsTaken<A>(
2020-11-15T22:52:40.2129510Z              ^
2020-11-15T22:52:40.2129810Z [767/796] Compiling PointFree PrivateRss.swift
2020-11-15T22:52:40.2131190Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/AccountMiddleware.swift:11:6: warning: global function 'accountMiddleware(conn:)' took 747ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2132450Z func accountMiddleware(conn: Conn<StatusLineOpen, Tuple4<Models.Subscription?, User?, SubscriberState, Account>>)
2020-11-15T22:52:40.2133060Z      ^
2020-11-15T22:52:40.2134040Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: closure took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2135070Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2135390Z            ^
2020-11-15T22:52:40.2136380Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: expression took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2137540Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2137870Z            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:40.2138960Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:116:14: warning: global function 'fetchSeatsTaken' took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2139750Z private func fetchSeatsTaken<A>(
2020-11-15T22:52:40.2140040Z              ^
2020-11-15T22:52:40.2140320Z [768/796] Compiling PointFree Team.swift
2020-11-15T22:52:40.2141650Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/AccountMiddleware.swift:11:6: warning: global function 'accountMiddleware(conn:)' took 747ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2142990Z func accountMiddleware(conn: Conn<StatusLineOpen, Tuple4<Models.Subscription?, User?, SubscriberState, Account>>)
2020-11-15T22:52:40.2143600Z      ^
2020-11-15T22:52:40.2144610Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: closure took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2145650Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2145970Z            ^
2020-11-15T22:52:40.2147200Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: expression took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2148340Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2148660Z            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:40.2149770Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:116:14: warning: global function 'fetchSeatsTaken' took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2150550Z private func fetchSeatsTaken<A>(
2020-11-15T22:52:40.2150840Z              ^
2020-11-15T22:52:40.2151180Z [769/796] Compiling PointFree UpdateProfile.swift
2020-11-15T22:52:40.2152590Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/AccountMiddleware.swift:11:6: warning: global function 'accountMiddleware(conn:)' took 747ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2154010Z func accountMiddleware(conn: Conn<StatusLineOpen, Tuple4<Models.Subscription?, User?, SubscriberState, Account>>)
2020-11-15T22:52:40.2154620Z      ^
2020-11-15T22:52:40.2155650Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: closure took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2156680Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2156990Z            ^
2020-11-15T22:52:40.2157980Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: expression took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2159020Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2159350Z            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:40.2160450Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:116:14: warning: global function 'fetchSeatsTaken' took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2161240Z private func fetchSeatsTaken<A>(
2020-11-15T22:52:40.2161530Z              ^
2020-11-15T22:52:40.2161890Z [770/796] Compiling PointFree AdminMiddleware.swift
2020-11-15T22:52:40.2163320Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/AccountMiddleware.swift:11:6: warning: global function 'accountMiddleware(conn:)' took 747ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2164560Z func accountMiddleware(conn: Conn<StatusLineOpen, Tuple4<Models.Subscription?, User?, SubscriberState, Account>>)
2020-11-15T22:52:40.2165160Z      ^
2020-11-15T22:52:40.2166140Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: closure took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2167180Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2167500Z            ^
2020-11-15T22:52:40.2168500Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: expression took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2169540Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2169860Z            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:40.2170970Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:116:14: warning: global function 'fetchSeatsTaken' took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2171750Z private func fetchSeatsTaken<A>(
2020-11-15T22:52:40.2172030Z              ^
2020-11-15T22:52:40.2172370Z [771/796] Compiling PointFree EpisodeCredit.swift
2020-11-15T22:52:40.2173790Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/AccountMiddleware.swift:11:6: warning: global function 'accountMiddleware(conn:)' took 747ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2175030Z func accountMiddleware(conn: Conn<StatusLineOpen, Tuple4<Models.Subscription?, User?, SubscriberState, Account>>)
2020-11-15T22:52:40.2175650Z      ^
2020-11-15T22:52:40.2176640Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: closure took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2177940Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2178280Z            ^
2020-11-15T22:52:40.2179320Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: expression took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2180370Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2180690Z            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:40.2181790Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:116:14: warning: global function 'fetchSeatsTaken' took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2182580Z private func fetchSeatsTaken<A>(
2020-11-15T22:52:40.2183050Z              ^
2020-11-15T22:52:40.2183390Z [772/796] Compiling PointFree FreeEpisodes.swift
2020-11-15T22:52:40.2184830Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/AccountMiddleware.swift:11:6: warning: global function 'accountMiddleware(conn:)' took 747ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2186070Z func accountMiddleware(conn: Conn<StatusLineOpen, Tuple4<Models.Subscription?, User?, SubscriberState, Account>>)
2020-11-15T22:52:40.2186680Z      ^
2020-11-15T22:52:40.2187670Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: closure took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2188700Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2189000Z            ^
2020-11-15T22:52:40.2189990Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: expression took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2191050Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2191370Z            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:40.2192470Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:116:14: warning: global function 'fetchSeatsTaken' took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2193270Z private func fetchSeatsTaken<A>(
2020-11-15T22:52:40.2193550Z              ^
2020-11-15T22:52:40.2193830Z [773/796] Compiling PointFree Ghost.swift
2020-11-15T22:52:40.2195180Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/AccountMiddleware.swift:11:6: warning: global function 'accountMiddleware(conn:)' took 747ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2196420Z func accountMiddleware(conn: Conn<StatusLineOpen, Tuple4<Models.Subscription?, User?, SubscriberState, Account>>)
2020-11-15T22:52:40.2197020Z      ^
2020-11-15T22:52:40.2198000Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: closure took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2199040Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2199360Z            ^
2020-11-15T22:52:40.2200350Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: expression took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2201400Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2201720Z            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:40.2202830Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:116:14: warning: global function 'fetchSeatsTaken' took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2203610Z private func fetchSeatsTaken<A>(
2020-11-15T22:52:40.2203880Z              ^
2020-11-15T22:52:40.2204160Z [774/796] Compiling PointFree Index.swift
2020-11-15T22:52:40.2205510Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/AccountMiddleware.swift:11:6: warning: global function 'accountMiddleware(conn:)' took 747ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2206760Z func accountMiddleware(conn: Conn<StatusLineOpen, Tuple4<Models.Subscription?, User?, SubscriberState, Account>>)
2020-11-15T22:52:40.2207500Z      ^
2020-11-15T22:52:40.2208730Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: closure took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2209830Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2210140Z            ^
2020-11-15T22:52:40.2211140Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: expression took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2212190Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2212500Z            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:40.2213610Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:116:14: warning: global function 'fetchSeatsTaken' took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2214570Z private func fetchSeatsTaken<A>(
2020-11-15T22:52:40.2214860Z              ^
2020-11-15T22:52:40.2215180Z [775/796] Compiling PointFree NewEpisodes.swift
2020-11-15T22:52:40.2216620Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/AccountMiddleware.swift:11:6: warning: global function 'accountMiddleware(conn:)' took 747ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2217860Z func accountMiddleware(conn: Conn<StatusLineOpen, Tuple4<Models.Subscription?, User?, SubscriberState, Account>>)
2020-11-15T22:52:40.2218470Z      ^
2020-11-15T22:52:40.2219450Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: closure took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2220480Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2220780Z            ^
2020-11-15T22:52:40.2221780Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: expression took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2222830Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2223160Z            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:40.2224260Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:116:14: warning: global function 'fetchSeatsTaken' took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2225060Z private func fetchSeatsTaken<A>(
2020-11-15T22:52:40.2225340Z              ^
2020-11-15T22:52:40.2225770Z [776/796] Compiling PointFree SendNewBlogPostMailer.swift
2020-11-15T22:52:40.2227270Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/AccountMiddleware.swift:11:6: warning: global function 'accountMiddleware(conn:)' took 747ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2228510Z func accountMiddleware(conn: Conn<StatusLineOpen, Tuple4<Models.Subscription?, User?, SubscriberState, Account>>)
2020-11-15T22:52:40.2229110Z      ^
2020-11-15T22:52:40.2230100Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: closure took 211ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2231130Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2231450Z            ^
2020-11-15T22:52:40.2232440Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:121:12: warning: expression took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2233490Z     return { conn -> IO<Conn<ResponseEnded, Data>> in
2020-11-15T22:52:40.2233820Z            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:40.2234920Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/Account/Change.swift:116:14: warning: global function 'fetchSeatsTaken' took 212ms to type-check (limit: 200ms)
2020-11-15T22:52:40.2235710Z private func fetchSeatsTaken<A>(
2020-11-15T22:52:40.2236000Z              ^
2020-11-15T22:52:42.2478170Z [777/796] Compiling PointFree Host.swift
2020-11-15T22:52:42.2486850Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/HtmlCssInliner.swift:19:14: warning: global function 'applyInlineStyles(tag:attribs:child:stylesheet:)' took 232ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2488560Z private func applyInlineStyles(
2020-11-15T22:52:42.2489210Z              ^
2020-11-15T22:52:42.2490750Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:58:52: warning: immutable value 'sectionSlug' was never used; consider replacing with '_' or removing it
2020-11-15T22:52:42.2492080Z     case let .collections(.episode(collectionSlug, sectionSlug, episodeParam)):
2020-11-15T22:52:42.2492780Z                                                    ^~~~~~~~~~~
2020-11-15T22:52:42.2493200Z                                                    _
2020-11-15T22:52:42.2494610Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:23:14: warning: global function 'render(conn:)' took 574ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2496500Z private func render(conn: Conn<StatusLineOpen, T3<(Models.Subscription, EnterpriseAccount?)?, User?, Route>>)
2020-11-15T22:52:42.2497260Z              ^
2020-11-15T22:52:42.2498500Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:16:5: warning: expression took 4085ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2499270Z     <| writeStatus(.ok)
2020-11-15T22:52:42.2499500Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:42.2500640Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:223:12: warning: expression took 239ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2501380Z           .flatMap(
2020-11-15T22:52:42.2501580Z ~~~~~~~~~~~^~~~~~~~
2020-11-15T22:52:42.2502690Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:203:14: warning: closure took 242ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2503440Z       return { conn in
2020-11-15T22:52:42.2503630Z              ^
2020-11-15T22:52:42.2504760Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:202:12: warning: expression took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2505540Z     return { middleware in
2020-11-15T22:52:42.2505790Z            ^~~~~~~~~~~~~~~
2020-11-15T22:52:42.2507140Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:196:6: warning: global function 'redirectActiveSubscribers(user:)' took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2508240Z func redirectActiveSubscribers<A>(
2020-11-15T22:52:42.2508600Z      ^
2020-11-15T22:52:42.2508950Z [778/796] Compiling PointFree HtmlCssInliner.swift
2020-11-15T22:52:42.2510410Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/HtmlCssInliner.swift:19:14: warning: global function 'applyInlineStyles(tag:attribs:child:stylesheet:)' took 232ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2511350Z private func applyInlineStyles(
2020-11-15T22:52:42.2511650Z              ^
2020-11-15T22:52:42.2512850Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:58:52: warning: immutable value 'sectionSlug' was never used; consider replacing with '_' or removing it
2020-11-15T22:52:42.2513880Z     case let .collections(.episode(collectionSlug, sectionSlug, episodeParam)):
2020-11-15T22:52:42.2514330Z                                                    ^~~~~~~~~~~
2020-11-15T22:52:42.2514540Z                                                    _
2020-11-15T22:52:42.2515650Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:23:14: warning: global function 'render(conn:)' took 574ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2516710Z private func render(conn: Conn<StatusLineOpen, T3<(Models.Subscription, EnterpriseAccount?)?, User?, Route>>)
2020-11-15T22:52:42.2517270Z              ^
2020-11-15T22:52:42.2518410Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:16:5: warning: expression took 4085ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2519170Z     <| writeStatus(.ok)
2020-11-15T22:52:42.2519390Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:42.2520820Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:223:12: warning: expression took 239ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2521590Z           .flatMap(
2020-11-15T22:52:42.2521790Z ~~~~~~~~~~~^~~~~~~~
2020-11-15T22:52:42.2522940Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:203:14: warning: closure took 242ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2523670Z       return { conn in
2020-11-15T22:52:42.2523880Z              ^
2020-11-15T22:52:42.2525010Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:202:12: warning: expression took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2525970Z     return { middleware in
2020-11-15T22:52:42.2526200Z            ^~~~~~~~~~~~~~~
2020-11-15T22:52:42.2527670Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:196:6: warning: global function 'redirectActiveSubscribers(user:)' took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2528780Z func redirectActiveSubscribers<A>(
2020-11-15T22:52:42.2529130Z      ^
2020-11-15T22:52:42.2529450Z [779/796] Compiling PointFree MetaLayout.swift
2020-11-15T22:52:42.2530890Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/HtmlCssInliner.swift:19:14: warning: global function 'applyInlineStyles(tag:attribs:child:stylesheet:)' took 232ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2531830Z private func applyInlineStyles(
2020-11-15T22:52:42.2532130Z              ^
2020-11-15T22:52:42.2533320Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:58:52: warning: immutable value 'sectionSlug' was never used; consider replacing with '_' or removing it
2020-11-15T22:52:42.2534350Z     case let .collections(.episode(collectionSlug, sectionSlug, episodeParam)):
2020-11-15T22:52:42.2534790Z                                                    ^~~~~~~~~~~
2020-11-15T22:52:42.2534990Z                                                    _
2020-11-15T22:52:42.2536110Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:23:14: warning: global function 'render(conn:)' took 574ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2537180Z private func render(conn: Conn<StatusLineOpen, T3<(Models.Subscription, EnterpriseAccount?)?, User?, Route>>)
2020-11-15T22:52:42.2537740Z              ^
2020-11-15T22:52:42.2538870Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:16:5: warning: expression took 4085ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2539630Z     <| writeStatus(.ok)
2020-11-15T22:52:42.2539860Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:42.2541000Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:223:12: warning: expression took 239ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2541730Z           .flatMap(
2020-11-15T22:52:42.2541920Z ~~~~~~~~~~~^~~~~~~~
2020-11-15T22:52:42.2543030Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:203:14: warning: closure took 242ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2543760Z       return { conn in
2020-11-15T22:52:42.2543970Z              ^
2020-11-15T22:52:42.2545100Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:202:12: warning: expression took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2545870Z     return { middleware in
2020-11-15T22:52:42.2546110Z            ^~~~~~~~~~~~~~~
2020-11-15T22:52:42.2547540Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:196:6: warning: global function 'redirectActiveSubscribers(user:)' took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2548640Z func redirectActiveSubscribers<A>(
2020-11-15T22:52:42.2548990Z      ^
2020-11-15T22:52:42.2549310Z [780/796] Compiling PointFree Newsletters.swift
2020-11-15T22:52:42.2550920Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/HtmlCssInliner.swift:19:14: warning: global function 'applyInlineStyles(tag:attribs:child:stylesheet:)' took 232ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2551900Z private func applyInlineStyles(
2020-11-15T22:52:42.2552190Z              ^
2020-11-15T22:52:42.2553430Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:58:52: warning: immutable value 'sectionSlug' was never used; consider replacing with '_' or removing it
2020-11-15T22:52:42.2554450Z     case let .collections(.episode(collectionSlug, sectionSlug, episodeParam)):
2020-11-15T22:52:42.2554900Z                                                    ^~~~~~~~~~~
2020-11-15T22:52:42.2555280Z                                                    _
2020-11-15T22:52:42.2556440Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:23:14: warning: global function 'render(conn:)' took 574ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2557500Z private func render(conn: Conn<StatusLineOpen, T3<(Models.Subscription, EnterpriseAccount?)?, User?, Route>>)
2020-11-15T22:52:42.2558060Z              ^
2020-11-15T22:52:42.2559200Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:16:5: warning: expression took 4085ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2559970Z     <| writeStatus(.ok)
2020-11-15T22:52:42.2560190Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:42.2561320Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:223:12: warning: expression took 239ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2562050Z           .flatMap(
2020-11-15T22:52:42.2562250Z ~~~~~~~~~~~^~~~~~~~
2020-11-15T22:52:42.2563370Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:203:14: warning: closure took 242ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2564090Z       return { conn in
2020-11-15T22:52:42.2564300Z              ^
2020-11-15T22:52:42.2565420Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:202:12: warning: expression took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2566200Z     return { middleware in
2020-11-15T22:52:42.2566440Z            ^~~~~~~~~~~~~~~
2020-11-15T22:52:42.2567800Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:196:6: warning: global function 'redirectActiveSubscribers(user:)' took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2568880Z func redirectActiveSubscribers<A>(
2020-11-15T22:52:42.2569240Z      ^
2020-11-15T22:52:42.2569550Z [781/796] Compiling PointFree PageLayout.swift
2020-11-15T22:52:42.2571260Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/HtmlCssInliner.swift:19:14: warning: global function 'applyInlineStyles(tag:attribs:child:stylesheet:)' took 232ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2572210Z private func applyInlineStyles(
2020-11-15T22:52:42.2572500Z              ^
2020-11-15T22:52:42.2573700Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:58:52: warning: immutable value 'sectionSlug' was never used; consider replacing with '_' or removing it
2020-11-15T22:52:42.2574730Z     case let .collections(.episode(collectionSlug, sectionSlug, episodeParam)):
2020-11-15T22:52:42.2575180Z                                                    ^~~~~~~~~~~
2020-11-15T22:52:42.2575380Z                                                    _
2020-11-15T22:52:42.2576500Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:23:14: warning: global function 'render(conn:)' took 574ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2577650Z private func render(conn: Conn<StatusLineOpen, T3<(Models.Subscription, EnterpriseAccount?)?, User?, Route>>)
2020-11-15T22:52:42.2578210Z              ^
2020-11-15T22:52:42.2579370Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:16:5: warning: expression took 4085ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2580140Z     <| writeStatus(.ok)
2020-11-15T22:52:42.2580570Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:42.2581770Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:223:12: warning: expression took 239ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2582520Z           .flatMap(
2020-11-15T22:52:42.2582710Z ~~~~~~~~~~~^~~~~~~~
2020-11-15T22:52:42.2583820Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:203:14: warning: closure took 242ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2584560Z       return { conn in
2020-11-15T22:52:42.2584760Z              ^
2020-11-15T22:52:42.2585890Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:202:12: warning: expression took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2587050Z     return { middleware in
2020-11-15T22:52:42.2587280Z            ^~~~~~~~~~~~~~~
2020-11-15T22:52:42.2588690Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:196:6: warning: global function 'redirectActiveSubscribers(user:)' took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2589780Z func redirectActiveSubscribers<A>(
2020-11-15T22:52:42.2590140Z      ^
2020-11-15T22:52:42.2590490Z [782/796] Compiling PointFree PricingLanding.swift
2020-11-15T22:52:42.2591940Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/HtmlCssInliner.swift:19:14: warning: global function 'applyInlineStyles(tag:attribs:child:stylesheet:)' took 232ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2592880Z private func applyInlineStyles(
2020-11-15T22:52:42.2593180Z              ^
2020-11-15T22:52:42.2594380Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:58:52: warning: immutable value 'sectionSlug' was never used; consider replacing with '_' or removing it
2020-11-15T22:52:42.2595400Z     case let .collections(.episode(collectionSlug, sectionSlug, episodeParam)):
2020-11-15T22:52:42.2595990Z                                                    ^~~~~~~~~~~
2020-11-15T22:52:42.2596190Z                                                    _
2020-11-15T22:52:42.2597330Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:23:14: warning: global function 'render(conn:)' took 574ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2598630Z private func render(conn: Conn<StatusLineOpen, T3<(Models.Subscription, EnterpriseAccount?)?, User?, Route>>)
2020-11-15T22:52:42.2599200Z              ^
2020-11-15T22:52:42.2600380Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:16:5: warning: expression took 4085ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2601160Z     <| writeStatus(.ok)
2020-11-15T22:52:42.2601390Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:42.2602520Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:223:12: warning: expression took 239ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2603260Z           .flatMap(
2020-11-15T22:52:42.2603450Z ~~~~~~~~~~~^~~~~~~~
2020-11-15T22:52:42.2604740Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:203:14: warning: closure took 242ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2605480Z       return { conn in
2020-11-15T22:52:42.2605680Z              ^
2020-11-15T22:52:42.2606850Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:202:12: warning: expression took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2607620Z     return { middleware in
2020-11-15T22:52:42.2607850Z            ^~~~~~~~~~~~~~~
2020-11-15T22:52:42.2609220Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:196:6: warning: global function 'redirectActiveSubscribers(user:)' took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2610310Z func redirectActiveSubscribers<A>(
2020-11-15T22:52:42.2610650Z      ^
2020-11-15T22:52:42.2610940Z [783/796] Compiling PointFree Privacy.swift
2020-11-15T22:52:42.2612500Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/HtmlCssInliner.swift:19:14: warning: global function 'applyInlineStyles(tag:attribs:child:stylesheet:)' took 232ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2613480Z private func applyInlineStyles(
2020-11-15T22:52:42.2613780Z              ^
2020-11-15T22:52:42.2615010Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:58:52: warning: immutable value 'sectionSlug' was never used; consider replacing with '_' or removing it
2020-11-15T22:52:42.2616030Z     case let .collections(.episode(collectionSlug, sectionSlug, episodeParam)):
2020-11-15T22:52:42.2616660Z                                                    ^~~~~~~~~~~
2020-11-15T22:52:42.2616860Z                                                    _
2020-11-15T22:52:42.2618020Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:23:14: warning: global function 'render(conn:)' took 574ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2619080Z private func render(conn: Conn<StatusLineOpen, T3<(Models.Subscription, EnterpriseAccount?)?, User?, Route>>)
2020-11-15T22:52:42.2619650Z              ^
2020-11-15T22:52:42.2621130Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:16:5: warning: expression took 4085ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2621960Z     <| writeStatus(.ok)
2020-11-15T22:52:42.2622190Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:42.2623560Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:223:12: warning: expression took 239ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2624320Z           .flatMap(
2020-11-15T22:52:42.2624820Z ~~~~~~~~~~~^~~~~~~~
2020-11-15T22:52:42.2626040Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:203:14: warning: closure took 242ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2626760Z       return { conn in
2020-11-15T22:52:42.2626980Z              ^
2020-11-15T22:52:42.2628130Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:202:12: warning: expression took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2628910Z     return { middleware in
2020-11-15T22:52:42.2629150Z            ^~~~~~~~~~~~~~~
2020-11-15T22:52:42.2630810Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:196:6: warning: global function 'redirectActiveSubscribers(user:)' took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2631930Z func redirectActiveSubscribers<A>(
2020-11-15T22:52:42.2632280Z      ^
2020-11-15T22:52:42.2632750Z [784/796] Compiling PointFree RouteNotFoundMiddleware.swift
2020-11-15T22:52:42.2634590Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/HtmlCssInliner.swift:19:14: warning: global function 'applyInlineStyles(tag:attribs:child:stylesheet:)' took 232ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2635560Z private func applyInlineStyles(
2020-11-15T22:52:42.2635860Z              ^
2020-11-15T22:52:42.2637130Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:58:52: warning: immutable value 'sectionSlug' was never used; consider replacing with '_' or removing it
2020-11-15T22:52:42.2638410Z     case let .collections(.episode(collectionSlug, sectionSlug, episodeParam)):
2020-11-15T22:52:42.2638860Z                                                    ^~~~~~~~~~~
2020-11-15T22:52:42.2639060Z                                                    _
2020-11-15T22:52:42.2640240Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:23:14: warning: global function 'render(conn:)' took 574ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2641320Z private func render(conn: Conn<StatusLineOpen, T3<(Models.Subscription, EnterpriseAccount?)?, User?, Route>>)
2020-11-15T22:52:42.2641870Z              ^
2020-11-15T22:52:42.2643250Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:16:5: warning: expression took 4085ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2644030Z     <| writeStatus(.ok)
2020-11-15T22:52:42.2644270Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:42.2645450Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:223:12: warning: expression took 239ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2646190Z           .flatMap(
2020-11-15T22:52:42.2646390Z ~~~~~~~~~~~^~~~~~~~
2020-11-15T22:52:42.2647620Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:203:14: warning: closure took 242ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2648560Z       return { conn in
2020-11-15T22:52:42.2648760Z              ^
2020-11-15T22:52:42.2650200Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:202:12: warning: expression took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2650970Z     return { middleware in
2020-11-15T22:52:42.2651220Z            ^~~~~~~~~~~~~~~
2020-11-15T22:52:42.2652870Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:196:6: warning: global function 'redirectActiveSubscribers(user:)' took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2653980Z func redirectActiveSubscribers<A>(
2020-11-15T22:52:42.2654330Z      ^
2020-11-15T22:52:42.2654800Z [785/796] Compiling PointFree ValidateEnterpriseEmails.swift
2020-11-15T22:52:42.2656380Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/HtmlCssInliner.swift:19:14: warning: global function 'applyInlineStyles(tag:attribs:child:stylesheet:)' took 232ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2657340Z private func applyInlineStyles(
2020-11-15T22:52:42.2657630Z              ^
2020-11-15T22:52:42.2658850Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:58:52: warning: immutable value 'sectionSlug' was never used; consider replacing with '_' or removing it
2020-11-15T22:52:42.2660120Z     case let .collections(.episode(collectionSlug, sectionSlug, episodeParam)):
2020-11-15T22:52:42.2660610Z                                                    ^~~~~~~~~~~
2020-11-15T22:52:42.2660810Z                                                    _
2020-11-15T22:52:42.2661990Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:23:14: warning: global function 'render(conn:)' took 574ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2663060Z private func render(conn: Conn<StatusLineOpen, T3<(Models.Subscription, EnterpriseAccount?)?, User?, Route>>)
2020-11-15T22:52:42.2663620Z              ^
2020-11-15T22:52:42.2664770Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:16:5: warning: expression took 4085ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2665530Z     <| writeStatus(.ok)
2020-11-15T22:52:42.2666000Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:42.2667230Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:223:12: warning: expression took 239ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2667960Z           .flatMap(
2020-11-15T22:52:42.2668160Z ~~~~~~~~~~~^~~~~~~~
2020-11-15T22:52:42.2669270Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:203:14: warning: closure took 242ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2670010Z       return { conn in
2020-11-15T22:52:42.2670220Z              ^
2020-11-15T22:52:42.2671360Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:202:12: warning: expression took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2672140Z     return { middleware in
2020-11-15T22:52:42.2672370Z            ^~~~~~~~~~~~~~~
2020-11-15T22:52:42.2673740Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:196:6: warning: global function 'redirectActiveSubscribers(user:)' took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2675080Z func redirectActiveSubscribers<A>(
2020-11-15T22:52:42.2675460Z      ^
2020-11-15T22:52:42.2675810Z [786/796] Compiling PointFree WelcomeEmails.swift
2020-11-15T22:52:42.2677300Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/HtmlCssInliner.swift:19:14: warning: global function 'applyInlineStyles(tag:attribs:child:stylesheet:)' took 232ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2678250Z private func applyInlineStyles(
2020-11-15T22:52:42.2678550Z              ^
2020-11-15T22:52:42.2679760Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:58:52: warning: immutable value 'sectionSlug' was never used; consider replacing with '_' or removing it
2020-11-15T22:52:42.2681350Z     case let .collections(.episode(collectionSlug, sectionSlug, episodeParam)):
2020-11-15T22:52:42.2681830Z                                                    ^~~~~~~~~~~
2020-11-15T22:52:42.2682030Z                                                    _
2020-11-15T22:52:42.2683220Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:23:14: warning: global function 'render(conn:)' took 574ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2684290Z private func render(conn: Conn<StatusLineOpen, T3<(Models.Subscription, EnterpriseAccount?)?, User?, Route>>)
2020-11-15T22:52:42.2684930Z              ^
2020-11-15T22:52:42.2686090Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:16:5: warning: expression took 4085ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2686860Z     <| writeStatus(.ok)
2020-11-15T22:52:42.2687090Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:42.2688240Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:223:12: warning: expression took 239ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2688980Z           .flatMap(
2020-11-15T22:52:42.2689170Z ~~~~~~~~~~~^~~~~~~~
2020-11-15T22:52:42.2690300Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:203:14: warning: closure took 242ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2691020Z       return { conn in
2020-11-15T22:52:42.2691220Z              ^
2020-11-15T22:52:42.2692360Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:202:12: warning: expression took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2693140Z     return { middleware in
2020-11-15T22:52:42.2693370Z            ^~~~~~~~~~~~~~~
2020-11-15T22:52:42.2694740Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:196:6: warning: global function 'redirectActiveSubscribers(user:)' took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2695830Z func redirectActiveSubscribers<A>(
2020-11-15T22:52:42.2696190Z      ^
2020-11-15T22:52:42.2696480Z [787/796] Compiling PointFree Session.swift
2020-11-15T22:52:42.2697880Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/HtmlCssInliner.swift:19:14: warning: global function 'applyInlineStyles(tag:attribs:child:stylesheet:)' took 232ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2698940Z private func applyInlineStyles(
2020-11-15T22:52:42.2699240Z              ^
2020-11-15T22:52:42.2700470Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:58:52: warning: immutable value 'sectionSlug' was never used; consider replacing with '_' or removing it
2020-11-15T22:52:42.2701500Z     case let .collections(.episode(collectionSlug, sectionSlug, episodeParam)):
2020-11-15T22:52:42.2701950Z                                                    ^~~~~~~~~~~
2020-11-15T22:52:42.2702150Z                                                    _
2020-11-15T22:52:42.2703290Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:23:14: warning: global function 'render(conn:)' took 574ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2704350Z private func render(conn: Conn<StatusLineOpen, T3<(Models.Subscription, EnterpriseAccount?)?, User?, Route>>)
2020-11-15T22:52:42.2705140Z              ^
2020-11-15T22:52:42.2706360Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:16:5: warning: expression took 4085ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2707280Z     <| writeStatus(.ok)
2020-11-15T22:52:42.2707510Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:42.2708690Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:223:12: warning: expression took 239ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2709430Z           .flatMap(
2020-11-15T22:52:42.2709630Z ~~~~~~~~~~~^~~~~~~~
2020-11-15T22:52:42.2710990Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:203:14: warning: closure took 242ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2711730Z       return { conn in
2020-11-15T22:52:42.2711930Z              ^
2020-11-15T22:52:42.2713080Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:202:12: warning: expression took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2713840Z     return { middleware in
2020-11-15T22:52:42.2714080Z            ^~~~~~~~~~~~~~~
2020-11-15T22:52:42.2715440Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:196:6: warning: global function 'redirectActiveSubscribers(user:)' took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2716540Z func redirectActiveSubscribers<A>(
2020-11-15T22:52:42.2716900Z      ^
2020-11-15T22:52:42.2717250Z [788/796] Compiling PointFree SiteMiddleware.swift
2020-11-15T22:52:42.2718700Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/HtmlCssInliner.swift:19:14: warning: global function 'applyInlineStyles(tag:attribs:child:stylesheet:)' took 232ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2719660Z private func applyInlineStyles(
2020-11-15T22:52:42.2719950Z              ^
2020-11-15T22:52:42.2721150Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:58:52: warning: immutable value 'sectionSlug' was never used; consider replacing with '_' or removing it
2020-11-15T22:52:42.2722170Z     case let .collections(.episode(collectionSlug, sectionSlug, episodeParam)):
2020-11-15T22:52:42.2722620Z                                                    ^~~~~~~~~~~
2020-11-15T22:52:42.2722820Z                                                    _
2020-11-15T22:52:42.2723940Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:23:14: warning: global function 'render(conn:)' took 574ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2725010Z private func render(conn: Conn<StatusLineOpen, T3<(Models.Subscription, EnterpriseAccount?)?, User?, Route>>)
2020-11-15T22:52:42.2725580Z              ^
2020-11-15T22:52:42.2726720Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:16:5: warning: expression took 4085ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2727490Z     <| writeStatus(.ok)
2020-11-15T22:52:42.2727720Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:42.2728850Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:223:12: warning: expression took 239ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2729600Z           .flatMap(
2020-11-15T22:52:42.2729800Z ~~~~~~~~~~~^~~~~~~~
2020-11-15T22:52:42.2730910Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:203:14: warning: closure took 242ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2731650Z       return { conn in
2020-11-15T22:52:42.2731860Z              ^
2020-11-15T22:52:42.2732990Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:202:12: warning: expression took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2733770Z     return { middleware in
2020-11-15T22:52:42.2734010Z            ^~~~~~~~~~~~~~~
2020-11-15T22:52:42.2735540Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:196:6: warning: global function 'redirectActiveSubscribers(user:)' took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2736650Z func redirectActiveSubscribers<A>(
2020-11-15T22:52:42.2737090Z      ^
2020-11-15T22:52:42.2737450Z [789/796] Compiling PointFree StripeWebhooks.swift
2020-11-15T22:52:42.2738960Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/HtmlCssInliner.swift:19:14: warning: global function 'applyInlineStyles(tag:attribs:child:stylesheet:)' took 232ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2739910Z private func applyInlineStyles(
2020-11-15T22:52:42.2740200Z              ^
2020-11-15T22:52:42.2741630Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:58:52: warning: immutable value 'sectionSlug' was never used; consider replacing with '_' or removing it
2020-11-15T22:52:42.2742660Z     case let .collections(.episode(collectionSlug, sectionSlug, episodeParam)):
2020-11-15T22:52:42.2743110Z                                                    ^~~~~~~~~~~
2020-11-15T22:52:42.2743320Z                                                    _
2020-11-15T22:52:42.2744430Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:23:14: warning: global function 'render(conn:)' took 574ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2745500Z private func render(conn: Conn<StatusLineOpen, T3<(Models.Subscription, EnterpriseAccount?)?, User?, Route>>)
2020-11-15T22:52:42.2746050Z              ^
2020-11-15T22:52:42.2747520Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:16:5: warning: expression took 4085ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2748320Z     <| writeStatus(.ok)
2020-11-15T22:52:42.2748540Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:42.2749740Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:223:12: warning: expression took 239ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2750480Z           .flatMap(
2020-11-15T22:52:42.2750680Z ~~~~~~~~~~~^~~~~~~~
2020-11-15T22:52:42.2751990Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:203:14: warning: closure took 242ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2752740Z       return { conn in
2020-11-15T22:52:42.2752950Z              ^
2020-11-15T22:52:42.2754130Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:202:12: warning: expression took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2754910Z     return { middleware in
2020-11-15T22:52:42.2755150Z            ^~~~~~~~~~~~~~~
2020-11-15T22:52:42.2756520Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:196:6: warning: global function 'redirectActiveSubscribers(user:)' took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2757620Z func redirectActiveSubscribers<A>(
2020-11-15T22:52:42.2757970Z      ^
2020-11-15T22:52:42.2758270Z [790/796] Compiling PointFree Subscribe.swift
2020-11-15T22:52:42.2759690Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/HtmlCssInliner.swift:19:14: warning: global function 'applyInlineStyles(tag:attribs:child:stylesheet:)' took 232ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2760640Z private func applyInlineStyles(
2020-11-15T22:52:42.2760940Z              ^
2020-11-15T22:52:42.2762150Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:58:52: warning: immutable value 'sectionSlug' was never used; consider replacing with '_' or removing it
2020-11-15T22:52:42.2763180Z     case let .collections(.episode(collectionSlug, sectionSlug, episodeParam)):
2020-11-15T22:52:42.2763640Z                                                    ^~~~~~~~~~~
2020-11-15T22:52:42.2763840Z                                                    _
2020-11-15T22:52:42.2764970Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:23:14: warning: global function 'render(conn:)' took 574ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2766210Z private func render(conn: Conn<StatusLineOpen, T3<(Models.Subscription, EnterpriseAccount?)?, User?, Route>>)
2020-11-15T22:52:42.2766800Z              ^
2020-11-15T22:52:42.2767970Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:16:5: warning: expression took 4085ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2768740Z     <| writeStatus(.ok)
2020-11-15T22:52:42.2768970Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:42.2770100Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:223:12: warning: expression took 239ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2771030Z           .flatMap(
2020-11-15T22:52:42.2771230Z ~~~~~~~~~~~^~~~~~~~
2020-11-15T22:52:42.2772390Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:203:14: warning: closure took 242ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2773120Z       return { conn in
2020-11-15T22:52:42.2773330Z              ^
2020-11-15T22:52:42.2774460Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:202:12: warning: expression took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2775240Z     return { middleware in
2020-11-15T22:52:42.2775480Z            ^~~~~~~~~~~~~~~
2020-11-15T22:52:42.2776830Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:196:6: warning: global function 'redirectActiveSubscribers(user:)' took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2777990Z func redirectActiveSubscribers<A>(
2020-11-15T22:52:42.2778350Z      ^
2020-11-15T22:52:42.2778780Z [791/796] Compiling PointFree SubscribeConfirmation.swift
2020-11-15T22:52:42.2780340Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/HtmlCssInliner.swift:19:14: warning: global function 'applyInlineStyles(tag:attribs:child:stylesheet:)' took 232ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2781290Z private func applyInlineStyles(
2020-11-15T22:52:42.2781990Z              ^
2020-11-15T22:52:42.2784500Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:58:52: warning: immutable value 'sectionSlug' was never used; consider replacing with '_' or removing it
2020-11-15T22:52:42.2785570Z     case let .collections(.episode(collectionSlug, sectionSlug, episodeParam)):
2020-11-15T22:52:42.2786030Z                                                    ^~~~~~~~~~~
2020-11-15T22:52:42.2786230Z                                                    _
2020-11-15T22:52:42.2787620Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:23:14: warning: global function 'render(conn:)' took 574ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2788720Z private func render(conn: Conn<StatusLineOpen, T3<(Models.Subscription, EnterpriseAccount?)?, User?, Route>>)
2020-11-15T22:52:42.2789290Z              ^
2020-11-15T22:52:42.2790500Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:16:5: warning: expression took 4085ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2791270Z     <| writeStatus(.ok)
2020-11-15T22:52:42.2791500Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:42.2792640Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:223:12: warning: expression took 239ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2793380Z           .flatMap(
2020-11-15T22:52:42.2793580Z ~~~~~~~~~~~^~~~~~~~
2020-11-15T22:52:42.2794690Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:203:14: warning: closure took 242ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2795810Z       return { conn in
2020-11-15T22:52:42.2796070Z              ^
2020-11-15T22:52:42.2804460Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:202:12: warning: expression took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2805300Z     return { middleware in
2020-11-15T22:52:42.2805820Z            ^~~~~~~~~~~~~~~
2020-11-15T22:52:42.2807340Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:196:6: warning: global function 'redirectActiveSubscribers(user:)' took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2808450Z func redirectActiveSubscribers<A>(
2020-11-15T22:52:42.2808800Z      ^
2020-11-15T22:52:42.2809080Z [792/796] Compiling PointFree TODO.swift
2020-11-15T22:52:42.2810470Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/HtmlCssInliner.swift:19:14: warning: global function 'applyInlineStyles(tag:attribs:child:stylesheet:)' took 232ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2811630Z private func applyInlineStyles(
2020-11-15T22:52:42.2811920Z              ^
2020-11-15T22:52:42.2813170Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:58:52: warning: immutable value 'sectionSlug' was never used; consider replacing with '_' or removing it
2020-11-15T22:52:42.2814200Z     case let .collections(.episode(collectionSlug, sectionSlug, episodeParam)):
2020-11-15T22:52:42.2814660Z                                                    ^~~~~~~~~~~
2020-11-15T22:52:42.2814840Z                                                    _
2020-11-15T22:52:42.2815960Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:23:14: warning: global function 'render(conn:)' took 574ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2817120Z private func render(conn: Conn<StatusLineOpen, T3<(Models.Subscription, EnterpriseAccount?)?, User?, Route>>)
2020-11-15T22:52:42.2817690Z              ^
2020-11-15T22:52:42.2818850Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:16:5: warning: expression took 4085ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2819630Z     <| writeStatus(.ok)
2020-11-15T22:52:42.2819860Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:42.2821000Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:223:12: warning: expression took 239ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2821740Z           .flatMap(
2020-11-15T22:52:42.2821940Z ~~~~~~~~~~~^~~~~~~~
2020-11-15T22:52:42.2823040Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:203:14: warning: closure took 242ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2823780Z       return { conn in
2020-11-15T22:52:42.2823990Z              ^
2020-11-15T22:52:42.2825110Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:202:12: warning: expression took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2825900Z     return { middleware in
2020-11-15T22:52:42.2826130Z            ^~~~~~~~~~~~~~~
2020-11-15T22:52:42.2827490Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:196:6: warning: global function 'redirectActiveSubscribers(user:)' took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2828580Z func redirectActiveSubscribers<A>(
2020-11-15T22:52:42.2828950Z      ^
2020-11-15T22:52:42.2829210Z [793/796] Compiling PointFree Util.swift
2020-11-15T22:52:42.2830590Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/HtmlCssInliner.swift:19:14: warning: global function 'applyInlineStyles(tag:attribs:child:stylesheet:)' took 232ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2831540Z private func applyInlineStyles(
2020-11-15T22:52:42.2831840Z              ^
2020-11-15T22:52:42.2833030Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:58:52: warning: immutable value 'sectionSlug' was never used; consider replacing with '_' or removing it
2020-11-15T22:52:42.2834060Z     case let .collections(.episode(collectionSlug, sectionSlug, episodeParam)):
2020-11-15T22:52:42.2834510Z                                                    ^~~~~~~~~~~
2020-11-15T22:52:42.2834710Z                                                    _
2020-11-15T22:52:42.2836030Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift:23:14: warning: global function 'render(conn:)' took 574ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2837120Z private func render(conn: Conn<StatusLineOpen, T3<(Models.Subscription, EnterpriseAccount?)?, User?, Route>>)
2020-11-15T22:52:42.2837680Z              ^
2020-11-15T22:52:42.2838840Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:16:5: warning: expression took 4085ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2839610Z     <| writeStatus(.ok)
2020-11-15T22:52:42.2839840Z ~~~~^~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:42.2840970Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:223:12: warning: expression took 239ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2841880Z           .flatMap(
2020-11-15T22:52:42.2842080Z ~~~~~~~~~~~^~~~~~~~
2020-11-15T22:52:42.2843240Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:203:14: warning: closure took 242ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2843970Z       return { conn in
2020-11-15T22:52:42.2844180Z              ^
2020-11-15T22:52:42.2845290Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:202:12: warning: expression took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2846070Z     return { middleware in
2020-11-15T22:52:42.2846310Z            ^~~~~~~~~~~~~~~
2020-11-15T22:52:42.2847760Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SubscribeConfirmation.swift:196:6: warning: global function 'redirectActiveSubscribers(user:)' took 245ms to type-check (limit: 200ms)
2020-11-15T22:52:42.2848870Z func redirectActiveSubscribers<A>(
2020-11-15T22:52:42.2849230Z      ^
2020-11-15T22:52:42.6479880Z [794/797] Merging module PointFree
2020-11-15T22:52:43.0756290Z [795/801] Compiling Runner main.swift
2020-11-15T22:52:43.2947410Z [797/803] Merging module Server
2020-11-15T22:52:43.3198670Z [798/803] Merging module Runner
2020-11-15T22:52:43.6957160Z [799/803] Compiling PointFreeTestSupport TestCase.swift
2020-11-15T22:52:43.6964950Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFreeTestSupport/TestCase.swift:62:21: warning: 'record' is deprecated: renamed to 'isRecording'
2020-11-15T22:52:43.6965840Z     SnapshotTesting.record = false
2020-11-15T22:52:43.6966170Z                     ^
2020-11-15T22:52:43.6967300Z /Users/runner/work/pointfreeco/pointfreeco/Sources/PointFreeTestSupport/TestCase.swift:62:21: note: use 'isRecording' instead
2020-11-15T22:52:43.6968060Z     SnapshotTesting.record = false
2020-11-15T22:52:43.6968390Z                     ^~~~~~
2020-11-15T22:52:43.6968630Z                     isRecording
2020-11-15T22:52:44.3684080Z [801/804] Linking Runner
2020-11-15T22:52:44.4210510Z [802/804] Linking Server
2020-11-15T22:52:44.4863570Z [803/804] Merging module PointFreeTestSupport
2020-11-15T22:52:48.4398600Z [804/849] Compiling PointFreeTests DatabaseTests.swift
2020-11-15T22:52:48.4409060Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:10:62: warning: closure took 291ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4410000Z     let thing = EitherIO<Prelude.Unit, Prelude.Unit>(run: IO {
2020-11-15T22:52:48.4413360Z                                                              ^
2020-11-15T22:52:48.4414600Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:14:8: warning: expression took 292ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4415390Z       .retry(maxRetries: 2)
2020-11-15T22:52:48.4415620Z ~~~~~~~^~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:48.4416790Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:8:8: warning: instance method 'testRetry_Fails()' took 293ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4417570Z   func testRetry_Fails() {
2020-11-15T22:52:48.4417810Z        ^
2020-11-15T22:52:48.4418190Z [805/849] Compiling PointFreeTests DiscountsTests.swift
2020-11-15T22:52:48.4420200Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:10:62: warning: closure took 291ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4421050Z     let thing = EitherIO<Prelude.Unit, Prelude.Unit>(run: IO {
2020-11-15T22:52:48.4421410Z                                                              ^
2020-11-15T22:52:48.4422560Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:14:8: warning: expression took 292ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4423260Z       .retry(maxRetries: 2)
2020-11-15T22:52:48.4423490Z ~~~~~~~^~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:48.4424640Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:8:8: warning: instance method 'testRetry_Fails()' took 293ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4425790Z   func testRetry_Fails() {
2020-11-15T22:52:48.4426030Z        ^
2020-11-15T22:52:48.4426400Z [806/849] Compiling PointFreeTests EitherIOTests.swift
2020-11-15T22:52:48.4427710Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:10:62: warning: closure took 291ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4428520Z     let thing = EitherIO<Prelude.Unit, Prelude.Unit>(run: IO {
2020-11-15T22:52:48.4428870Z                                                              ^
2020-11-15T22:52:48.4429960Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:14:8: warning: expression took 292ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4430670Z       .retry(maxRetries: 2)
2020-11-15T22:52:48.4430900Z ~~~~~~~^~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:48.4432060Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:8:8: warning: instance method 'testRetry_Fails()' took 293ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4432830Z   func testRetry_Fails() {
2020-11-15T22:52:48.4433060Z        ^
2020-11-15T22:52:48.4433610Z [807/849] Compiling PointFreeTests ChangeEmailConfirmationTests.swift
2020-11-15T22:52:48.4435050Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:10:62: warning: closure took 291ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4435860Z     let thing = EitherIO<Prelude.Unit, Prelude.Unit>(run: IO {
2020-11-15T22:52:48.4436220Z                                                              ^
2020-11-15T22:52:48.4437380Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:14:8: warning: expression took 292ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4438100Z       .retry(maxRetries: 2)
2020-11-15T22:52:48.4438330Z ~~~~~~~^~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:48.4439510Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:8:8: warning: instance method 'testRetry_Fails()' took 293ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4440280Z   func testRetry_Fails() {
2020-11-15T22:52:48.4440510Z        ^
2020-11-15T22:52:48.4440980Z [808/849] Compiling PointFreeTests FreeEpisodeEmailTests.swift
2020-11-15T22:52:48.4442320Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:10:62: warning: closure took 291ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4443120Z     let thing = EitherIO<Prelude.Unit, Prelude.Unit>(run: IO {
2020-11-15T22:52:48.4443470Z                                                              ^
2020-11-15T22:52:48.4444540Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:14:8: warning: expression took 292ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4445250Z       .retry(maxRetries: 2)
2020-11-15T22:52:48.4445480Z ~~~~~~~^~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:48.4446640Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:8:8: warning: instance method 'testRetry_Fails()' took 293ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4447490Z   func testRetry_Fails() {
2020-11-15T22:52:48.4447720Z        ^
2020-11-15T22:52:48.4448380Z [809/849] Compiling PointFreeTests InviteEmailTests.swift
2020-11-15T22:52:48.4449740Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:10:62: warning: closure took 291ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4450550Z     let thing = EitherIO<Prelude.Unit, Prelude.Unit>(run: IO {
2020-11-15T22:52:48.4450890Z                                                              ^
2020-11-15T22:52:48.4451970Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:14:8: warning: expression took 292ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4452680Z       .retry(maxRetries: 2)
2020-11-15T22:52:48.4453170Z ~~~~~~~^~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:48.4454360Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:8:8: warning: instance method 'testRetry_Fails()' took 293ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4455130Z   func testRetry_Fails() {
2020-11-15T22:52:48.4455360Z        ^
2020-11-15T22:52:48.4455830Z [810/849] Compiling PointFreeTests NewBlogPostEmailTests.swift
2020-11-15T22:52:48.4457170Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:10:62: warning: closure took 291ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4457960Z     let thing = EitherIO<Prelude.Unit, Prelude.Unit>(run: IO {
2020-11-15T22:52:48.4458320Z                                                              ^
2020-11-15T22:52:48.4459400Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:14:8: warning: expression took 292ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4460110Z       .retry(maxRetries: 2)
2020-11-15T22:52:48.4460350Z ~~~~~~~^~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:48.4461500Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:8:8: warning: instance method 'testRetry_Fails()' took 293ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4462270Z   func testRetry_Fails() {
2020-11-15T22:52:48.4462500Z        ^
2020-11-15T22:52:48.4462950Z [811/849] Compiling PointFreeTests NewEpisodeEmailTests.swift
2020-11-15T22:52:48.4464270Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:10:62: warning: closure took 291ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4465080Z     let thing = EitherIO<Prelude.Unit, Prelude.Unit>(run: IO {
2020-11-15T22:52:48.4465440Z                                                              ^
2020-11-15T22:52:48.4466530Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:14:8: warning: expression took 292ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4467230Z       .retry(maxRetries: 2)
2020-11-15T22:52:48.4467470Z ~~~~~~~^~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:48.4468610Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:8:8: warning: instance method 'testRetry_Fails()' took 293ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4469380Z   func testRetry_Fails() {
2020-11-15T22:52:48.4469610Z        ^
2020-11-15T22:52:48.4470040Z [812/849] Compiling PointFreeTests ReferralEmailTests.swift
2020-11-15T22:52:48.4471350Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:10:62: warning: closure took 291ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4472160Z     let thing = EitherIO<Prelude.Unit, Prelude.Unit>(run: IO {
2020-11-15T22:52:48.4472520Z                                                              ^
2020-11-15T22:52:48.4473610Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:14:8: warning: expression took 292ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4474320Z       .retry(maxRetries: 2)
2020-11-15T22:52:48.4474540Z ~~~~~~~^~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:48.4475690Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:8:8: warning: instance method 'testRetry_Fails()' took 293ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4476460Z   func testRetry_Fails() {
2020-11-15T22:52:48.4476920Z        ^
2020-11-15T22:52:48.4477520Z [813/849] Compiling PointFreeTests RegistrationEmailTests.swift
2020-11-15T22:52:48.4478920Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:10:62: warning: closure took 291ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4479730Z     let thing = EitherIO<Prelude.Unit, Prelude.Unit>(run: IO {
2020-11-15T22:52:48.4480090Z                                                              ^
2020-11-15T22:52:48.4481170Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:14:8: warning: expression took 292ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4482130Z       .retry(maxRetries: 2)
2020-11-15T22:52:48.4482360Z ~~~~~~~^~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:48.4483540Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:8:8: warning: instance method 'testRetry_Fails()' took 293ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4484320Z   func testRetry_Fails() {
2020-11-15T22:52:48.4484550Z        ^
2020-11-15T22:52:48.4484950Z [814/849] Compiling PointFreeTests TeamEmailsTests.swift
2020-11-15T22:52:48.4486220Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:10:62: warning: closure took 291ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4487030Z     let thing = EitherIO<Prelude.Unit, Prelude.Unit>(run: IO {
2020-11-15T22:52:48.4487380Z                                                              ^
2020-11-15T22:52:48.4488470Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:14:8: warning: expression took 292ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4489410Z       .retry(maxRetries: 2)
2020-11-15T22:52:48.4489650Z ~~~~~~~^~~~~~~~~~~~~~~~~~~~
2020-11-15T22:52:48.4490820Z /Users/runner/work/pointfreeco/pointfreeco/Tests/PointFreeTests/EitherIOTests.swift:8:8: warning: instance method 'testRetry_Fails()' took 293ms to type-check (limit: 200ms)
2020-11-15T22:52:48.4491600Z   func testRetry_Fails() {
2020-11-15T22:52:48.4491830Z        ^
2020-11-15T22:52:49.1057000Z [815/849] Compiling PointFreeTests AboutTests.swift
2020-11-15T22:52:49.1062100Z [816/849] Compiling PointFreeTests AccountTests.swift
2020-11-15T22:52:49.1062680Z [817/849] Compiling PointFreeTests CancelTests.swift
2020-11-15T22:52:49.1063220Z [818/849] Compiling PointFreeTests ChangeTests.swift
2020-11-15T22:52:49.1064660Z [819/849] Compiling PointFreeTests PaymentInfoTests.swift
2020-11-15T22:52:49.1065350Z [820/849] Compiling PointFreeTests UpdateProfileTests.swift
2020-11-15T22:52:49.1065930Z [821/849] Compiling PointFreeTests ApiTests.swift
2020-11-15T22:52:49.1067000Z [822/849] Compiling PointFreeTests AppleDeveloperMerchantIdDomainAssociationTests.swift
2020-11-15T22:52:49.1068120Z [823/849] Compiling PointFreeTests AtomFeedTests.swift
2020-11-15T22:52:49.1068660Z [824/849] Compiling PointFreeTests AuthTests.swift
2020-11-15T22:52:49.1071930Z [825/849] Compiling PointFreeTests BlogTests.swift
2020-11-15T22:52:49.1072780Z [826/849] Compiling PointFreeTests CollectionsTests.swift
2020-11-15T22:52:49.4985200Z [827/849] Compiling PointFreeTests WelcomeEmailTests.swift
2020-11-15T22:52:49.4985990Z [828/849] Compiling PointFreeTests EnterpriseTests.swift
2020-11-15T22:52:49.4986580Z [829/849] Compiling PointFreeTests EnvVarTests.swift
2020-11-15T22:52:49.4990120Z [830/849] Compiling PointFreeTests EnvironmentTests.swift
2020-11-15T22:52:49.4990940Z [831/849] Compiling PointFreeTests EpisodePageTests.swift
2020-11-15T22:52:49.4992040Z [832/849] Compiling PointFreeTests GhostTests.swift
2020-11-15T22:52:49.4992560Z [833/849] Compiling PointFreeTests HomeTests.swift
2020-11-15T22:52:49.4993190Z [834/849] Compiling PointFreeTests HtmlCssInlinerTests.swift
2020-11-15T22:52:49.4994820Z [835/849] Compiling PointFreeTests InviteTests.swift
2020-11-15T22:52:49.4995780Z [836/849] Compiling PointFreeTests InvoicesTests.swift
2020-11-15T22:52:49.4996410Z [837/849] Compiling PointFreeTests MetaLayoutTests.swift
2020-11-15T22:52:50.3444490Z [838/849] Compiling PointFreeTests MinimalNavViewTests.swift
2020-11-15T22:52:50.3445330Z [839/849] Compiling PointFreeTests NewslettersTests.swift
2020-11-15T22:52:50.3447810Z [840/849] Compiling PointFreeTests NotFoundMiddlewareTests.swift
2020-11-15T22:52:50.3448620Z [841/849] Compiling PointFreeTests PricingLandingTests.swift
2020-11-15T22:52:50.3451650Z [842/849] Compiling PointFreeTests PrivacyTests.swift
2020-11-15T22:52:50.3452240Z [843/849] Compiling PointFreeTests PrivateRssTests.swift
2020-11-15T22:52:50.3452810Z [844/849] Compiling PointFreeTests SessionTests.swift
2020-11-15T22:52:50.3453420Z [845/849] Compiling PointFreeTests SiteMiddlewareTests.swift
2020-11-15T22:52:50.3454470Z [846/849] Compiling PointFreeTests StripeWebhooksTests.swift
2020-11-15T22:52:50.3455230Z [847/849] Compiling PointFreeTests SubscribeConfirmationTests.swift
2020-11-15T22:52:50.3455950Z [848/849] Compiling PointFreeTests SubscribeTests.swift
2020-11-15T22:52:50.9582600Z [849/850] Merging module PointFreeTests
2020-11-15T22:52:52.5210220Z [850/850] Linking PointFreePackageTests
2020-11-15T22:52:53.1837100Z Test Suite 'All tests' started at 2020-11-15 22:52:53.183
2020-11-15T22:52:53.1838270Z Test Suite 'PointFreePackageTests.xctest' started at 2020-11-15 22:52:53.183
2020-11-15T22:52:53.1839190Z Test Suite 'AboutTests' started at 2020-11-15 22:52:53.184
2020-11-15T22:52:53.1840090Z Test Case '-[PointFreeTests.AboutTests testAbout]' started.
2020-11-15T22:52:53.3415970Z 2020-11-15T22:52:53+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift D34F055D-7366-4B47-85FE-FF8C31814C4B [Request] GET /about
2020-11-15T22:52:53.3889360Z 2020-11-15T22:52:53+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 D34F055D-7366-4B47-85FE-FF8C31814C4B [Time] 47ms
2020-11-15T22:52:53.3908510Z Test Case '-[PointFreeTests.AboutTests testAbout]' passed (0.207 seconds).
2020-11-15T22:52:53.3909510Z Test Suite 'AboutTests' passed at 2020-11-15 22:52:53.391.
2020-11-15T22:52:53.3909940Z    Executed 1 test, with 0 failures (0 unexpected) in 0.207 (0.207) seconds
2020-11-15T22:52:53.3910850Z Test Suite 'AccountIntegrationTests' started at 2020-11-15 22:52:53.391
2020-11-15T22:52:53.3912050Z Test Case '-[PointFreeTests.AccountIntegrationTests testLeaveTeam]' started.
2020-11-15T22:52:54.8853200Z 2020-11-15T22:52:54+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 4A5941C6-FB38-4CA5-92A4-FC059E131150 [Request] POST /account/team/leave
2020-11-15T22:52:54.9234510Z 2020-11-15T22:52:54+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 4A5941C6-FB38-4CA5-92A4-FC059E131150 [Time] 38ms
2020-11-15T22:52:54.9353780Z Test Case '-[PointFreeTests.AccountIntegrationTests testLeaveTeam]' passed (1.544 seconds).
2020-11-15T22:52:54.9355220Z Test Suite 'AccountIntegrationTests' passed at 2020-11-15 22:52:54.935.
2020-11-15T22:52:54.9355790Z    Executed 1 test, with 0 failures (0 unexpected) in 1.544 (1.544) seconds
2020-11-15T22:52:54.9356950Z Test Suite 'AccountTests' started at 2020-11-15 22:52:54.935
2020-11-15T22:52:54.9358110Z Test Case '-[PointFreeTests.AccountTests testAccount]' started.
2020-11-15T22:52:54.9380050Z 2020-11-15T22:52:54+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 C65BFC5B-D58B-4207-96F9-59D9BB4D3931 [Request] GET /account
2020-11-15T22:52:54.9864230Z 2020-11-15T22:52:54+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 C65BFC5B-D58B-4207-96F9-59D9BB4D3931 [Time] 48ms
2020-11-15T22:52:54.9874570Z Test Case '-[PointFreeTests.AccountTests testAccount]' passed (0.052 seconds).
2020-11-15T22:52:54.9876180Z Test Case '-[PointFreeTests.AccountTests testAccount_InvoiceBilling]' started.
2020-11-15T22:52:54.9895340Z 2020-11-15T22:52:54+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 0C6028F5-6DE9-4E4C-A62E-CBCFAC474E79 [Request] GET /account
2020-11-15T22:52:55.0349510Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 0C6028F5-6DE9-4E4C-A62E-CBCFAC474E79 [Time] 45ms
2020-11-15T22:52:55.0359760Z Test Case '-[PointFreeTests.AccountTests testAccount_InvoiceBilling]' passed (0.048 seconds).
2020-11-15T22:52:55.0361710Z Test Case '-[PointFreeTests.AccountTests testAccount_WithExtraInvoiceInfo]' started.
2020-11-15T22:52:55.0381100Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 F53B8959-93C6-49CC-A175-02E17C9F2616 [Request] GET /account
2020-11-15T22:52:55.0794970Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 F53B8959-93C6-49CC-A175-02E17C9F2616 [Time] 41ms
2020-11-15T22:52:55.0805200Z Test Case '-[PointFreeTests.AccountTests testAccount_WithExtraInvoiceInfo]' passed (0.044 seconds).
2020-11-15T22:52:55.0811580Z Test Case '-[PointFreeTests.AccountTests testAccountCanceledSubscription]' started.
2020-11-15T22:52:55.0825400Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 81187219-5BBA-42F8-A25E-B5B91984864F [Request] GET /account
2020-11-15T22:52:55.1178020Z Test Case '-[PointFreeTests.AccountTests testAccountCanceledSubscription]' passed (0.037 seconds).
2020-11-15T22:52:55.1180060Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 81187219-5BBA-42F8-A25E-B5B91984864F [Time] 33ms
2020-11-15T22:52:55.1252630Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 1232E770-2F39-4A53-B1FC-0C26930E65A4 [Request] GET /account
2020-11-15T22:52:55.1275100Z Test Case '-[PointFreeTests.AccountTests testAccountCancelingSubscription]' started.
2020-11-15T22:52:55.1573900Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 1232E770-2F39-4A53-B1FC-0C26930E65A4 [Time] 37ms
2020-11-15T22:52:55.1585560Z Test Case '-[PointFreeTests.AccountTests testAccountCancelingSubscription]' passed (0.041 seconds).
2020-11-15T22:52:55.1588180Z Test Case '-[PointFreeTests.AccountTests testAccountWithCredit]' started.
2020-11-15T22:52:55.1610050Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 DA5E7781-8A94-4903-87CB-6C56387B37ED [Request] GET /account
2020-11-15T22:52:55.2015630Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift DA5E7781-8A94-4903-87CB-6C56387B37ED [Time] 40ms
2020-11-15T22:52:55.2026470Z Test Case '-[PointFreeTests.AccountTests testAccountWithCredit]' passed (0.044 seconds).
2020-11-15T22:52:55.2027880Z Test Case '-[PointFreeTests.AccountTests testAccountWithDiscount]' started.
2020-11-15T22:52:55.2047480Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 F7FB5D81-61E8-4F4F-9368-8373FFB5597F [Request] GET /account
2020-11-15T22:52:55.2472020Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 F7FB5D81-61E8-4F4F-9368-8373FFB5597F [Time] 42ms
2020-11-15T22:52:55.2481420Z Test Case '-[PointFreeTests.AccountTests testAccountWithDiscount]' passed (0.045 seconds).
2020-11-15T22:52:55.2482860Z Test Case '-[PointFreeTests.AccountTests testAccountWithFlashError]' started.
2020-11-15T22:52:55.2502560Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift B446A787-BD78-4854-A13D-D68320720724 [Request] GET /account
2020-11-15T22:52:55.2932090Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift B446A787-BD78-4854-A13D-D68320720724 [Time] 42ms
2020-11-15T22:52:55.2942370Z Test Case '-[PointFreeTests.AccountTests testAccountWithFlashError]' passed (0.046 seconds).
2020-11-15T22:52:55.2943840Z Test Case '-[PointFreeTests.AccountTests testAccountWithFlashNotice]' started.
2020-11-15T22:52:55.2965200Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift FC046C1B-DB49-4CED-B860-D6E8D3E41A64 [Request] GET /account
2020-11-15T22:52:55.3427870Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift FC046C1B-DB49-4CED-B860-D6E8D3E41A64 [Time] 45ms
2020-11-15T22:52:55.3432510Z Test Case '-[PointFreeTests.AccountTests testAccountWithFlashNotice]' passed (0.049 seconds).
2020-11-15T22:52:55.3435330Z Test Case '-[PointFreeTests.AccountTests testAccountWithFlashWarning]' started.
2020-11-15T22:52:55.3506290Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 681BE838-FB2D-44CB-97C9-C32D3A799F0A [Request] GET /account
2020-11-15T22:52:55.3932840Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 681BE838-FB2D-44CB-97C9-C32D3A799F0A [Time] 42ms
2020-11-15T22:52:55.3941810Z Test Case '-[PointFreeTests.AccountTests testAccountWithFlashWarning]' passed (0.051 seconds).
2020-11-15T22:52:55.3943290Z Test Case '-[PointFreeTests.AccountTests testAccountWithPastDue]' started.
2020-11-15T22:52:55.3965180Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 933AC6C2-1A68-4A61-A435-1C7A9E96F6DE [Request] GET /account
2020-11-15T22:52:55.4354150Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 933AC6C2-1A68-4A61-A435-1C7A9E96F6DE [Time] 38ms
2020-11-15T22:52:55.4361570Z Test Case '-[PointFreeTests.AccountTests testAccountWithPastDue]' passed (0.042 seconds).
2020-11-15T22:52:55.4363030Z Test Case '-[PointFreeTests.AccountTests testEpisodeCredits_1Credit_1Chosen]' started.
2020-11-15T22:52:55.4382160Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 5DE98086-2CBF-4B00-9169-186AA8AED7B1 [Request] GET /account
2020-11-15T22:52:55.4706090Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 5DE98086-2CBF-4B00-9169-186AA8AED7B1 [Time] 32ms
2020-11-15T22:52:55.4717670Z Test Case '-[PointFreeTests.AccountTests testEpisodeCredits_1Credit_1Chosen]' passed (0.035 seconds).
2020-11-15T22:52:55.4719150Z Test Case '-[PointFreeTests.AccountTests testEpisodeCredits_1Credit_NoneChosen]' started.
2020-11-15T22:52:55.4737370Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift CD7B708A-3CE0-42C5-A2D6-70223F0CF2F0 [Request] GET /account
2020-11-15T22:52:55.5044810Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 CD7B708A-3CE0-42C5-A2D6-70223F0CF2F0 [Time] 30ms
2020-11-15T22:52:55.5054210Z Test Case '-[PointFreeTests.AccountTests testEpisodeCredits_1Credit_NoneChosen]' passed (0.034 seconds).
2020-11-15T22:52:55.5055600Z Test Case '-[PointFreeTests.AccountTests testTeam_AsTeammate]' started.
2020-11-15T22:52:55.5074720Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 0E6C71B3-42BA-44CB-9F53-026DD096F445 [Request] GET /account
2020-11-15T22:52:55.5402600Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 0E6C71B3-42BA-44CB-9F53-026DD096F445 [Time] 32ms
2020-11-15T22:52:55.5413170Z Test Case '-[PointFreeTests.AccountTests testTeam_AsTeammate]' passed (0.036 seconds).
2020-11-15T22:52:55.5414550Z Test Case '-[PointFreeTests.AccountTests testTeam_NoRemainingSeats]' started.
2020-11-15T22:52:55.5433530Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 9AE8B18E-1D2B-4D7A-ADC5-14A7651DD51A [Request] GET /account
2020-11-15T22:52:55.5857890Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 9AE8B18E-1D2B-4D7A-ADC5-14A7651DD51A [Time] 42ms
2020-11-15T22:52:55.5867950Z Test Case '-[PointFreeTests.AccountTests testTeam_NoRemainingSeats]' passed (0.045 seconds).
2020-11-15T22:52:55.5869780Z Test Case '-[PointFreeTests.AccountTests testTeam_OwnerIsNotSubscriber]' started.
2020-11-15T22:52:55.5889490Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 09C8B9B9-BC8E-4171-9D95-E089FB4C48AB [Request] GET /account
2020-11-15T22:52:55.6327220Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 09C8B9B9-BC8E-4171-9D95-E089FB4C48AB [Time] 43ms
2020-11-15T22:52:55.6337940Z Test Case '-[PointFreeTests.AccountTests testTeam_OwnerIsNotSubscriber]' passed (0.047 seconds).
2020-11-15T22:52:55.6339130Z Test Suite 'AccountTests' passed at 2020-11-15 22:52:55.634.
2020-11-15T22:52:55.6340120Z    Executed 16 tests, with 0 failures (0 unexpected) in 0.698 (0.698) seconds
2020-11-15T22:52:55.6341220Z Test Suite 'ApiTests' started at 2020-11-15 22:52:55.634
2020-11-15T22:52:55.6342110Z Test Case '-[PointFreeTests.ApiTests testEpisode]' started.
2020-11-15T22:52:55.6361910Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift EBAE01B1-7E9C-4F02-83E2-2449741CE521 [Request] GET /api/episodes/1
2020-11-15T22:52:55.6383750Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 EBAE01B1-7E9C-4F02-83E2-2449741CE521 [Time] 2ms
2020-11-15T22:52:55.6392730Z Test Case '-[PointFreeTests.ApiTests testEpisode]' passed (0.005 seconds).
2020-11-15T22:52:55.6394080Z Test Case '-[PointFreeTests.ApiTests testEpisode_NotFound]' started.
2020-11-15T22:52:55.6410930Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 9EBBD82E-26C2-49E3-A5CD-94512E105F61 [Request] GET /api/episodes/424242
2020-11-15T22:52:55.6740280Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 9EBBD82E-26C2-49E3-A5CD-94512E105F61 [Time] 32ms
2020-11-15T22:52:55.6750360Z Test Case '-[PointFreeTests.ApiTests testEpisode_NotFound]' passed (0.036 seconds).
2020-11-15T22:52:55.6751510Z Test Case '-[PointFreeTests.ApiTests testEpisodes]' started.
2020-11-15T22:52:55.6770740Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 05D99342-F3E1-45D8-BFB6-F78AB4D0D630 [Request] GET /api/episodes
2020-11-15T22:52:55.6780480Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 05D99342-F3E1-45D8-BFB6-F78AB4D0D630 [Time] 0ms
2020-11-15T22:52:55.6791820Z Test Case '-[PointFreeTests.ApiTests testEpisodes]' passed (0.004 seconds).
2020-11-15T22:52:55.6793100Z Test Suite 'ApiTests' passed at 2020-11-15 22:52:55.679.
2020-11-15T22:52:55.6793570Z    Executed 3 tests, with 0 failures (0 unexpected) in 0.045 (0.045) seconds
2020-11-15T22:52:55.6794980Z Test Suite 'AppleDeveloperMerchantIdDomainAssociationTests' started at 2020-11-15 22:52:55.679
2020-11-15T22:52:55.6797210Z Test Case '-[PointFreeTests.AppleDeveloperMerchantIdDomainAssociationTests testNotLoggedIn_IndividualMonthly]' started.
2020-11-15T22:52:55.6816480Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift D0F4226A-F4FF-40BF-8782-DC04AC48E17A [Request] GET /.well-known/apple-developer-merchantid-domain-association
2020-11-15T22:52:55.6823610Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift D0F4226A-F4FF-40BF-8782-DC04AC48E17A [Time] 0ms
2020-11-15T22:52:55.6832210Z Test Case '-[PointFreeTests.AppleDeveloperMerchantIdDomainAssociationTests testNotLoggedIn_IndividualMonthly]' passed (0.004 seconds).
2020-11-15T22:52:55.6834670Z Test Suite 'AppleDeveloperMerchantIdDomainAssociationTests' passed at 2020-11-15 22:52:55.683.
2020-11-15T22:52:55.6836250Z    Executed 1 test, with 0 failures (0 unexpected) in 0.004 (0.004) seconds
2020-11-15T22:52:55.6837620Z Test Suite 'AtomFeedTests' started at 2020-11-15 22:52:55.683
2020-11-15T22:52:55.6838610Z Test Case '-[PointFreeTests.AtomFeedTests testAtomFeed]' started.
2020-11-15T22:52:55.6858680Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 BBDBC8C9-377C-47EE-93C2-1BF3237AEF65 [Request] GET /feed/atom.xml
2020-11-15T22:52:55.6906920Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 BBDBC8C9-377C-47EE-93C2-1BF3237AEF65 [Time] 4ms
2020-11-15T22:52:55.6910560Z Test Case '-[PointFreeTests.AtomFeedTests testAtomFeed]' passed (0.008 seconds).
2020-11-15T22:52:55.6911840Z Test Case '-[PointFreeTests.AtomFeedTests testEpisodeFeed]' started.
2020-11-15T22:52:55.6933500Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 3D189D2A-77C5-4032-891D-532EDF8E131A [Request] GET /feed/episodes.xml
2020-11-15T22:52:55.6972430Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 3D189D2A-77C5-4032-891D-532EDF8E131A [Time] 3ms
2020-11-15T22:52:55.6979730Z Test Case '-[PointFreeTests.AtomFeedTests testEpisodeFeed]' passed (0.007 seconds).
2020-11-15T22:52:55.6981390Z Test Case '-[PointFreeTests.AtomFeedTests testEpisodeFeed_WithRecentlyFreeEpisode]' started.
2020-11-15T22:52:55.7008830Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 05DE8A3A-C819-445C-B5FE-226C2449AA2D [Request] GET /feed/episodes.xml
2020-11-15T22:52:55.7053430Z 2020-11-15T22:52:55+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 05DE8A3A-C819-445C-B5FE-226C2449AA2D [Time] 4ms
2020-11-15T22:52:55.7060930Z Test Case '-[PointFreeTests.AtomFeedTests testEpisodeFeed_WithRecentlyFreeEpisode]' passed (0.008 seconds).
2020-11-15T22:52:55.7062560Z Test Suite 'AtomFeedTests' passed at 2020-11-15 22:52:55.706.
2020-11-15T22:52:55.7063040Z    Executed 3 tests, with 0 failures (0 unexpected) in 0.023 (0.023) seconds
2020-11-15T22:52:55.7064040Z Test Suite 'AuthIntegrationTests' started at 2020-11-15 22:52:55.706
2020-11-15T22:52:55.7065550Z Test Case '-[PointFreeTests.AuthIntegrationTests testAuth]' started.
2020-11-15T22:52:55.7587060Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:52:55.7588160Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:52:55.7589690Z drop cascades to extension uuid-ossp
2020-11-15T22:52:55.7590570Z drop cascades to extension citext
2020-11-15T22:52:55.7591300Z drop cascades to table users
2020-11-15T22:52:55.7592040Z drop cascades to table subscriptions
2020-11-15T22:52:55.7592800Z drop cascades to table team_invites
2020-11-15T22:52:55.7593540Z drop cascades to table email_settings
2020-11-15T22:52:55.7594300Z drop cascades to table episode_credits
2020-11-15T22:52:55.7595070Z drop cascades to table feed_request_events
2020-11-15T22:52:55.7595830Z drop cascades to function update_updated_at()
2020-11-15T22:52:55.7596630Z drop cascades to table enterprise_accounts
2020-11-15T22:52:55.7597420Z drop cascades to table enterprise_emails
2020-11-15T22:52:55.7598220Z drop cascades to table episode_progresses
2020-11-15T22:52:55.7599020Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:52:55.7599800Z drop cascades to sequence test_uuids
2020-11-15T22:52:55.7600550Z drop cascades to sequence test_shortids
2020-11-15T22:52:56.7468480Z 2020-11-15T22:52:56+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 81ED8E06-D130-47AA-BB60-06AC94ED6E1B [Request] GET /github-auth
2020-11-15T22:52:56.9437950Z 2020-11-15T22:52:56+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 81ED8E06-D130-47AA-BB60-06AC94ED6E1B [Time] 196ms
2020-11-15T22:52:56.9444110Z Test Case '-[PointFreeTests.AuthIntegrationTests testAuth]' passed (1.238 seconds).
2020-11-15T22:52:56.9445600Z Test Case '-[PointFreeTests.AuthIntegrationTests testLoginWithRedirect]' started.
2020-11-15T22:52:56.9600010Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:52:56.9601570Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:52:56.9603050Z drop cascades to extension uuid-ossp
2020-11-15T22:52:56.9603740Z drop cascades to extension citext
2020-11-15T22:52:56.9604420Z drop cascades to table users
2020-11-15T22:52:56.9605040Z drop cascades to table subscriptions
2020-11-15T22:52:56.9605650Z drop cascades to table team_invites
2020-11-15T22:52:56.9606240Z drop cascades to table email_settings
2020-11-15T22:52:56.9606840Z drop cascades to table episode_credits
2020-11-15T22:52:56.9607450Z drop cascades to table feed_request_events
2020-11-15T22:52:56.9608080Z drop cascades to function update_updated_at()
2020-11-15T22:52:56.9608720Z drop cascades to table enterprise_accounts
2020-11-15T22:52:56.9609350Z drop cascades to table enterprise_emails
2020-11-15T22:52:56.9609980Z drop cascades to table episode_progresses
2020-11-15T22:52:56.9610630Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:52:56.9611270Z drop cascades to sequence test_uuids
2020-11-15T22:52:56.9611880Z drop cascades to sequence test_shortids
2020-11-15T22:52:57.9147240Z 2020-11-15T22:52:57+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 A04CD553-F346-4CAA-BF23-72791E062B1C [Request] GET /login
2020-11-15T22:52:57.9245040Z 2020-11-15T22:52:57+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift A04CD553-F346-4CAA-BF23-72791E062B1C [Time] 9ms
2020-11-15T22:52:57.9250510Z Test Case '-[PointFreeTests.AuthIntegrationTests testLoginWithRedirect]' passed (0.981 seconds).
2020-11-15T22:52:57.9253290Z Test Case '-[PointFreeTests.AuthIntegrationTests testRegister]' started.
2020-11-15T22:52:57.9384790Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:52:57.9385400Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:52:57.9386990Z drop cascades to extension uuid-ossp
2020-11-15T22:52:57.9387380Z drop cascades to extension citext
2020-11-15T22:52:57.9387720Z drop cascades to table users
2020-11-15T22:52:57.9388070Z drop cascades to table subscriptions
2020-11-15T22:52:57.9388440Z drop cascades to table team_invites
2020-11-15T22:52:57.9388780Z drop cascades to table email_settings
2020-11-15T22:52:57.9389160Z drop cascades to table episode_credits
2020-11-15T22:52:57.9389540Z drop cascades to table feed_request_events
2020-11-15T22:52:57.9389930Z drop cascades to function update_updated_at()
2020-11-15T22:52:57.9390340Z drop cascades to table enterprise_accounts
2020-11-15T22:52:57.9390740Z drop cascades to table enterprise_emails
2020-11-15T22:52:57.9391140Z drop cascades to table episode_progresses
2020-11-15T22:52:57.9391540Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:52:57.9391940Z drop cascades to sequence test_uuids
2020-11-15T22:52:57.9392300Z drop cascades to sequence test_shortids
2020-11-15T22:52:58.7860970Z 2020-11-15T22:52:58+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 C24057B3-D996-4241-BE50-6B96BDDFEE79 [Request] GET /github-auth
2020-11-15T22:52:58.9800740Z 2020-11-15T22:52:58+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 C24057B3-D996-4241-BE50-6B96BDDFEE79 [Time] 193ms
2020-11-15T22:52:58.9889740Z Test Case '-[PointFreeTests.AuthIntegrationTests testRegister]' passed (1.064 seconds).
2020-11-15T22:52:58.9892000Z Test Suite 'AuthIntegrationTests' passed at 2020-11-15 22:52:58.989.
2020-11-15T22:52:58.9893030Z    Executed 3 tests, with 0 failures (0 unexpected) in 3.283 (3.283) seconds
2020-11-15T22:52:58.9894150Z Test Suite 'AuthTests' started at 2020-11-15 22:52:58.989
2020-11-15T22:52:58.9895640Z Test Case '-[PointFreeTests.AuthTests testAuth_WithFetchAuthTokenBadVerificationCode]' started.
2020-11-15T22:52:58.9925990Z 2020-11-15T22:52:58+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift E0E320BD-BB81-4198-9335-30D5ADB42568 [Request] GET /github-auth
2020-11-15T22:52:58.9945190Z 2020-11-15T22:52:58+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift E0E320BD-BB81-4198-9335-30D5ADB42568 [Time] 2ms
2020-11-15T22:52:58.9952530Z Test Case '-[PointFreeTests.AuthTests testAuth_WithFetchAuthTokenBadVerificationCode]' passed (0.006 seconds).
2020-11-15T22:52:58.9961720Z Test Case '-[PointFreeTests.AuthTests testAuth_WithFetchAuthTokenBadVerificationCodeRedirect]' started.
2020-11-15T22:52:58.9996110Z 2020-11-15T22:52:58+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 6F815C8E-C35E-4A4E-8A63-94C9FBCB616D [Request] GET /github-auth
2020-11-15T22:52:59.0019860Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 6F815C8E-C35E-4A4E-8A63-94C9FBCB616D [Time] 2ms
2020-11-15T22:52:59.0026900Z Test Case '-[PointFreeTests.AuthTests testAuth_WithFetchAuthTokenBadVerificationCodeRedirect]' passed (0.007 seconds).
2020-11-15T22:52:59.0029290Z Test Case '-[PointFreeTests.AuthTests testAuth_WithFetchAuthTokenFailure]' started.
2020-11-15T22:52:59.0058860Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 B5D2F280-D22B-4B29-83F2-8A056915802C [Request] GET /github-auth
2020-11-15T22:52:59.0073110Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift B5D2F280-D22B-4B29-83F2-8A056915802C [Time] 1ms
2020-11-15T22:52:59.0078990Z Test Case '-[PointFreeTests.AuthTests testAuth_WithFetchAuthTokenFailure]' passed (0.005 seconds).
2020-11-15T22:52:59.0081050Z Test Case '-[PointFreeTests.AuthTests testAuth_WithFetchUserFailure]' started.
2020-11-15T22:52:59.0110330Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 1425DBD4-62BA-43D1-B7A3-5289F13ADB47 [Request] GET /github-auth
2020-11-15T22:52:59.0127560Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 1425DBD4-62BA-43D1-B7A3-5289F13ADB47 [Time] 1ms
2020-11-15T22:52:59.0134320Z Test Case '-[PointFreeTests.AuthTests testAuth_WithFetchUserFailure]' passed (0.006 seconds).
2020-11-15T22:52:59.0135790Z Test Case '-[PointFreeTests.AuthTests testHome_LoggedIn]' started.
2020-11-15T22:52:59.0156520Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 9C517EC1-871D-4F33-AB2E-D7B29F5BA0D4 [Request] GET
2020-11-15T22:52:59.0548300Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 9C517EC1-871D-4F33-AB2E-D7B29F5BA0D4 [Time] 39ms
2020-11-15T22:52:59.0556710Z Test Case '-[PointFreeTests.AuthTests testHome_LoggedIn]' passed (0.042 seconds).
2020-11-15T22:52:59.0558140Z Test Case '-[PointFreeTests.AuthTests testHome_LoggedOut]' started.
2020-11-15T22:52:59.0578380Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 9EDF928B-9A67-4085-B8E8-A146157DBE5C [Request] GET
2020-11-15T22:52:59.0973540Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 9EDF928B-9A67-4085-B8E8-A146157DBE5C [Time] 39ms
2020-11-15T22:52:59.0981740Z Test Case '-[PointFreeTests.AuthTests testHome_LoggedOut]' passed (0.042 seconds).
2020-11-15T22:52:59.0984950Z Test Case '-[PointFreeTests.AuthTests testLogin]' started.
2020-11-15T22:52:59.1045240Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 46C8FDA5-F694-4D14-B3ED-DF1751326CEB [Request] GET /login
2020-11-15T22:52:59.1087040Z Test Case '-[PointFreeTests.AuthTests testLogin]' passed (0.007 seconds).
2020-11-15T22:52:59.1089220Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 46C8FDA5-F694-4D14-B3ED-DF1751326CEB [Time] 2ms
2020-11-15T22:52:59.1091240Z Test Case '-[PointFreeTests.AuthTests testLogin_AlreadyLoggedIn]' started.
2020-11-15T22:52:59.1093010Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 1A36C095-C950-4EA6-9A69-6B219BA786D8 [Request] GET /login
2020-11-15T22:52:59.1097510Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 1A36C095-C950-4EA6-9A69-6B219BA786D8 [Time] 1ms
2020-11-15T22:52:59.1104810Z Test Case '-[PointFreeTests.AuthTests testLogin_AlreadyLoggedIn]' passed (0.005 seconds).
2020-11-15T22:52:59.1118690Z Test Case '-[PointFreeTests.AuthTests testLogout]' started.
2020-11-15T22:52:59.1131430Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 B8C16D79-59DF-454F-A56F-E200958A5CDC [Request] GET /logout
2020-11-15T22:52:59.1140200Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift B8C16D79-59DF-454F-A56F-E200958A5CDC [Time] 1ms
2020-11-15T22:52:59.1145220Z Test Case '-[PointFreeTests.AuthTests testLogout]' passed (0.004 seconds).
2020-11-15T22:52:59.1149450Z Test Suite 'AuthTests' passed at 2020-11-15 22:52:59.114.
2020-11-15T22:52:59.1163460Z    Executed 9 tests, with 0 failures (0 unexpected) in 0.125 (0.125) seconds
2020-11-15T22:52:59.1164590Z Test Suite 'BlogPostTests' started at 2020-11-15 22:52:59.114
2020-11-15T22:52:59.1166500Z Test Case '-[ModelsTests.BlogPostTests testSlug]' started.
2020-11-15T22:52:59.1167950Z Test Case '-[ModelsTests.BlogPostTests testSlug]' passed (0.000 seconds).
2020-11-15T22:52:59.1169930Z Test Suite 'BlogPostTests' passed at 2020-11-15 22:52:59.115.
2020-11-15T22:52:59.1170790Z    Executed 1 test, with 0 failures (0 unexpected) in 0.000 (0.000) seconds
2020-11-15T22:52:59.1171660Z Test Suite 'BlogTests' started at 2020-11-15 22:52:59.115
2020-11-15T22:52:59.1173280Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 51286411-A81C-4E85-9905-2F0C56612799 [Request] GET /blog/feed/atom.xml
2020-11-15T22:52:59.1175350Z Test Case '-[PointFreeTests.BlogTests testBlogAtomFeed]' started.
2020-11-15T22:52:59.1236530Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 51286411-A81C-4E85-9905-2F0C56612799 [Time] 6ms
2020-11-15T22:52:59.1244600Z Test Case '-[PointFreeTests.BlogTests testBlogAtomFeed]' passed (0.009 seconds).
2020-11-15T22:52:59.1246660Z Test Case '-[PointFreeTests.BlogTests testBlogAtomFeed_Unauthed]' started.
2020-11-15T22:52:59.1284100Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift DCE1A3BA-7AD1-4D04-81E7-BE2D9ED503FB [Request] GET /blog/feed/atom.xml
2020-11-15T22:52:59.1321800Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift DCE1A3BA-7AD1-4D04-81E7-BE2D9ED503FB [Time] 5ms
2020-11-15T22:52:59.1421770Z Test Case '-[PointFreeTests.BlogTests testBlogAtomFeed_Unauthed]' passed (0.009 seconds).
2020-11-15T22:52:59.1423940Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 924D06E7-F3DA-40E4-8FBF-84F3930CB051 [Request] GET /blog
2020-11-15T22:52:59.1522660Z Test Case '-[PointFreeTests.BlogTests testBlogIndex]' started.
2020-11-15T22:52:59.1765680Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 924D06E7-F3DA-40E4-8FBF-84F3930CB051 [Time] 40ms
2020-11-15T22:52:59.1848080Z Test Case '-[PointFreeTests.BlogTests testBlogIndex]' passed (0.046 seconds).
2020-11-15T22:52:59.1859280Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift E076DBBA-3AB4-423E-82B5-12D9BD1E3A78 [Request] GET /blog
2020-11-15T22:52:59.1873110Z Test Case '-[PointFreeTests.BlogTests testBlogIndex_WithLotsOfPosts]' started.
2020-11-15T22:52:59.2273690Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift E076DBBA-3AB4-423E-82B5-12D9BD1E3A78 [Time] 46ms
2020-11-15T22:52:59.2287260Z Test Case '-[PointFreeTests.BlogTests testBlogIndex_WithLotsOfPosts]' passed (0.050 seconds).
2020-11-15T22:52:59.2295840Z Test Case '-[PointFreeTests.BlogTests testBlogShow]' started.
2020-11-15T22:52:59.2315210Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift EFA22E54-7AE5-420C-8C16-45B8F5FB024C [Request] GET /blog/posts/0-mock-blog-post
2020-11-15T22:52:59.2692700Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 EFA22E54-7AE5-420C-8C16-45B8F5FB024C [Time] 37ms
2020-11-15T22:52:59.2703490Z Test Case '-[PointFreeTests.BlogTests testBlogShow]' passed (0.042 seconds).
2020-11-15T22:52:59.2704720Z Test Case '-[PointFreeTests.BlogTests testBlogShow_Unauthed]' started.
2020-11-15T22:52:59.2734400Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 524C4D11-88DB-41EB-83AA-1049AC2AF88C [Request] GET /blog/posts/0-mock-blog-post
2020-11-15T22:52:59.3119470Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 524C4D11-88DB-41EB-83AA-1049AC2AF88C [Time] 38ms
2020-11-15T22:52:59.3131830Z Test Case '-[PointFreeTests.BlogTests testBlogShow_Unauthed]' passed (0.043 seconds).
2020-11-15T22:52:59.3133030Z Test Suite 'BlogTests' passed at 2020-11-15 22:52:59.313.
2020-11-15T22:52:59.3133470Z    Executed 6 tests, with 0 failures (0 unexpected) in 0.198 (0.198) seconds
2020-11-15T22:52:59.3134260Z Test Suite 'CancelTests' started at 2020-11-15 22:52:59.313
2020-11-15T22:52:59.3135210Z Test Case '-[PointFreeTests.CancelTests testCancel]' started.
2020-11-15T22:52:59.3159360Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 82D86C3C-8343-4468-9994-1852457B3C87 [Request] POST /account/subscription/cancel
2020-11-15T22:52:59.3624280Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 82D86C3C-8343-4468-9994-1852457B3C87 [Time] 46ms
2020-11-15T22:52:59.3631460Z Test Case '-[PointFreeTests.CancelTests testCancel]' passed (0.050 seconds).
2020-11-15T22:52:59.3632870Z Test Case '-[PointFreeTests.CancelTests testCancelCanceledSubscription]' started.
2020-11-15T22:52:59.3655860Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift EC621325-9BD7-4887-81FB-70960864BC39 [Request] POST /account/subscription/cancel
2020-11-15T22:52:59.3668500Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift EC621325-9BD7-4887-81FB-70960864BC39 [Time] 1ms
2020-11-15T22:52:59.3675270Z Test Case '-[PointFreeTests.CancelTests testCancelCanceledSubscription]' passed (0.004 seconds).
2020-11-15T22:52:59.3676920Z Test Case '-[PointFreeTests.CancelTests testCancelCancelingSubscription]' started.
2020-11-15T22:52:59.3697210Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 29EE9CCE-4E59-486D-BFDA-7D7DFAAC8E3A [Request] POST /account/subscription/cancel
2020-11-15T22:52:59.3708350Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 29EE9CCE-4E59-486D-BFDA-7D7DFAAC8E3A [Time] 1ms
2020-11-15T22:52:59.3714150Z Test Case '-[PointFreeTests.CancelTests testCancelCancelingSubscription]' passed (0.004 seconds).
2020-11-15T22:52:59.3715830Z Test Case '-[PointFreeTests.CancelTests testCancelEmail]' started.
2020-11-15T22:52:59.4145000Z Test Case '-[PointFreeTests.CancelTests testCancelEmail]' passed (0.043 seconds).
2020-11-15T22:52:59.4147290Z Test Case '-[PointFreeTests.CancelTests testCancelLoggedOut]' started.
2020-11-15T22:52:59.4169900Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 1AA11D9F-D032-4960-AFDE-0081005B9F4A [Request] POST /account/subscription/cancel
2020-11-15T22:52:59.4196110Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 1AA11D9F-D032-4960-AFDE-0081005B9F4A [Time] 2ms
2020-11-15T22:52:59.4203690Z Test Case '-[PointFreeTests.CancelTests testCancelLoggedOut]' passed (0.006 seconds).
2020-11-15T22:52:59.4206590Z Test Case '-[PointFreeTests.CancelTests testCancelNoSubscription]' started.
2020-11-15T22:52:59.4231030Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 83546FBD-B87C-4515-9782-B0475A922C45 [Request] POST /account/subscription/cancel
2020-11-15T22:52:59.4245270Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 83546FBD-B87C-4515-9782-B0475A922C45 [Time] 1ms
2020-11-15T22:52:59.4251910Z Test Case '-[PointFreeTests.CancelTests testCancelNoSubscription]' passed (0.005 seconds).
2020-11-15T22:52:59.4254010Z Test Case '-[PointFreeTests.CancelTests testCancelStripeFailure]' started.
2020-11-15T22:52:59.4274080Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 2CAB75E2-C669-4C2A-9F18-78A7B19873D2 [Request] POST /account/subscription/cancel
2020-11-15T22:52:59.4288690Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 2CAB75E2-C669-4C2A-9F18-78A7B19873D2 [Time] 1ms
2020-11-15T22:52:59.4296480Z Test Case '-[PointFreeTests.CancelTests testCancelStripeFailure]' passed (0.004 seconds).
2020-11-15T22:52:59.4297800Z Test Case '-[PointFreeTests.CancelTests testReactivate]' started.
2020-11-15T22:52:59.4320130Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 1A4EAC50-5309-4832-95FF-FE9D100D1990 [Request] POST /account/subscription/reactivate
2020-11-15T22:52:59.4764310Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 1A4EAC50-5309-4832-95FF-FE9D100D1990 [Time] 44ms
2020-11-15T22:52:59.4770940Z Test Case '-[PointFreeTests.CancelTests testReactivate]' passed (0.047 seconds).
2020-11-15T22:52:59.4772390Z Test Case '-[PointFreeTests.CancelTests testReactivateActiveSubscription]' started.
2020-11-15T22:52:59.4796640Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 863B82F3-BFEE-4962-95D9-74035101914A [Request] POST /account/subscription/reactivate
2020-11-15T22:52:59.4808720Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 863B82F3-BFEE-4962-95D9-74035101914A [Time] 1ms
2020-11-15T22:52:59.4815400Z Test Case '-[PointFreeTests.CancelTests testReactivateActiveSubscription]' passed (0.004 seconds).
2020-11-15T22:52:59.4817240Z Test Case '-[PointFreeTests.CancelTests testReactivateCanceledSubscription]' started.
2020-11-15T22:52:59.4840510Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 45374B86-0B89-4F15-9E35-7153F37068FF [Request] POST /account/subscription/reactivate
2020-11-15T22:52:59.4852940Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 45374B86-0B89-4F15-9E35-7153F37068FF [Time] 1ms
2020-11-15T22:52:59.4859380Z Test Case '-[PointFreeTests.CancelTests testReactivateCanceledSubscription]' passed (0.004 seconds).
2020-11-15T22:52:59.4862170Z Test Case '-[PointFreeTests.CancelTests testReactivateEmail]' started.
2020-11-15T22:52:59.5302210Z Test Case '-[PointFreeTests.CancelTests testReactivateEmail]' passed (0.044 seconds).
2020-11-15T22:52:59.5303770Z Test Case '-[PointFreeTests.CancelTests testReactivateLoggedOut]' started.
2020-11-15T22:52:59.5327600Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 171A0030-A56E-48F3-AE68-F98698358DC6 [Request] POST /account/subscription/reactivate
2020-11-15T22:52:59.5350310Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 171A0030-A56E-48F3-AE68-F98698358DC6 [Time] 2ms
2020-11-15T22:52:59.5357160Z Test Case '-[PointFreeTests.CancelTests testReactivateLoggedOut]' passed (0.006 seconds).
2020-11-15T22:52:59.5358630Z Test Case '-[PointFreeTests.CancelTests testReactivateNoSubscription]' started.
2020-11-15T22:52:59.5381360Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift AF4C1D89-F205-4ADC-87A4-500EB983DA8F [Request] POST /account/subscription/reactivate
2020-11-15T22:52:59.5392270Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift AF4C1D89-F205-4ADC-87A4-500EB983DA8F [Time] 1ms
2020-11-15T22:52:59.5398410Z Test Case '-[PointFreeTests.CancelTests testReactivateNoSubscription]' passed (0.004 seconds).
2020-11-15T22:52:59.5399930Z Test Case '-[PointFreeTests.CancelTests testReactivateStripeFailure]' started.
2020-11-15T22:52:59.5422570Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 85FE4D10-9CFB-4BB8-A507-388C998EC77A [Request] POST /account/subscription/reactivate
2020-11-15T22:52:59.5434340Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 85FE4D10-9CFB-4BB8-A507-388C998EC77A [Time] 1ms
2020-11-15T22:52:59.5442740Z Test Case '-[PointFreeTests.CancelTests testReactivateStripeFailure]' passed (0.004 seconds).
2020-11-15T22:52:59.5443930Z Test Suite 'CancelTests' passed at 2020-11-15 22:52:59.544.
2020-11-15T22:52:59.5444370Z    Executed 14 tests, with 0 failures (0 unexpected) in 0.230 (0.231) seconds
2020-11-15T22:52:59.5445380Z Test Suite 'ChangeEmailConfirmationTests' started at 2020-11-15 22:52:59.544
2020-11-15T22:52:59.5449460Z Test Case '-[PointFreeTests.ChangeEmailConfirmationTests testChangedEmail]' started.
2020-11-15T22:52:59.5911320Z Test Case '-[PointFreeTests.ChangeEmailConfirmationTests testChangedEmail]' passed (0.046 seconds).
2020-11-15T22:52:59.5919700Z Test Case '-[PointFreeTests.ChangeEmailConfirmationTests testChangeEmailConfirmationEmail]' started.
2020-11-15T22:52:59.6403770Z Test Case '-[PointFreeTests.ChangeEmailConfirmationTests testChangeEmailConfirmationEmail]' passed (0.049 seconds).
2020-11-15T22:52:59.6405530Z Test Suite 'ChangeEmailConfirmationTests' passed at 2020-11-15 22:52:59.640.
2020-11-15T22:52:59.6406480Z    Executed 2 tests, with 0 failures (0 unexpected) in 0.095 (0.096) seconds
2020-11-15T22:52:59.6407370Z Test Suite 'ChangeTests' started at 2020-11-15 22:52:59.640
2020-11-15T22:52:59.6408640Z Test Case '-[PointFreeTests.ChangeTests testChangeRedirect]' started.
2020-11-15T22:52:59.6429840Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 2FECC484-2F4F-4BB3-97B0-F57767C49D80 [Request] GET /account/subscription/change
2020-11-15T22:52:59.6440830Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 2FECC484-2F4F-4BB3-97B0-F57767C49D80 [Time] 1ms
2020-11-15T22:52:59.6447210Z Test Case '-[PointFreeTests.ChangeTests testChangeRedirect]' passed (0.004 seconds).
2020-11-15T22:52:59.6448840Z Test Case '-[PointFreeTests.ChangeTests testChangeUpdateAddSeatsIndividualPlan]' started.
2020-11-15T22:52:59.6487410Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 A2F33E18-E9FD-4B75-AFEA-A4AF914018AC [Request] POST /account/subscription/change
2020-11-15T22:52:59.6525010Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift A2F33E18-E9FD-4B75-AFEA-A4AF914018AC [Time] 3ms
2020-11-15T22:52:59.6532740Z Test Case '-[PointFreeTests.ChangeTests testChangeUpdateAddSeatsIndividualPlan]' passed (0.008 seconds).
2020-11-15T22:52:59.6534510Z Test Case '-[PointFreeTests.ChangeTests testChangeUpdateAddSeatsTeamPlan]' started.
2020-11-15T22:52:59.6565070Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 6FAB1D54-6B92-425F-8005-2CAE06ADAC00 [Request] POST /account/subscription/change
2020-11-15T22:52:59.6587230Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 6FAB1D54-6B92-425F-8005-2CAE06ADAC00 [Time] 2ms
2020-11-15T22:52:59.6598730Z Test Case '-[PointFreeTests.ChangeTests testChangeUpdateAddSeatsTeamPlan]' passed (0.007 seconds).
2020-11-15T22:52:59.6601160Z Test Case '-[PointFreeTests.ChangeTests testChangeUpdateDowngradeIndividualPlan]' started.
2020-11-15T22:52:59.6634390Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift ACF904E0-6BDC-4A17-B4F7-4F497854FDDB [Request] POST /account/subscription/change
2020-11-15T22:52:59.6656910Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift ACF904E0-6BDC-4A17-B4F7-4F497854FDDB [Time] 2ms
2020-11-15T22:52:59.6668130Z Test Case '-[PointFreeTests.ChangeTests testChangeUpdateDowngradeIndividualPlan]' passed (0.007 seconds).
2020-11-15T22:52:59.6669950Z Test Case '-[PointFreeTests.ChangeTests testChangeUpdateDowngradeTeamPlan]' started.
2020-11-15T22:52:59.6707020Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 36E21F8B-2DDE-44CE-85F7-6258CBF5E856 [Request] POST /account/subscription/change
2020-11-15T22:52:59.6733150Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 36E21F8B-2DDE-44CE-85F7-6258CBF5E856 [Time] 2ms
2020-11-15T22:52:59.6740180Z Test Case '-[PointFreeTests.ChangeTests testChangeUpdateDowngradeTeamPlan]' passed (0.007 seconds).
2020-11-15T22:52:59.6741970Z Test Case '-[PointFreeTests.ChangeTests testChangeUpdateRemoveSeats]' started.
2020-11-15T22:52:59.6778860Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 0255A954-CB06-4582-B0F0-1D11AFF16474 [Request] POST /account/subscription/change
2020-11-15T22:52:59.6798670Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 0255A954-CB06-4582-B0F0-1D11AFF16474 [Time] 2ms
2020-11-15T22:52:59.6804310Z Test Case '-[PointFreeTests.ChangeTests testChangeUpdateRemoveSeats]' passed (0.006 seconds).
2020-11-15T22:52:59.6806650Z Test Case '-[PointFreeTests.ChangeTests testChangeUpdateRemoveSeatsInvalidNumber]' started.
2020-11-15T22:52:59.6836780Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 4B90232D-99D5-4F9C-995A-BE812B959E59 [Request] POST /account/subscription/change
2020-11-15T22:52:59.6861590Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 4B90232D-99D5-4F9C-995A-BE812B959E59 [Time] 2ms
2020-11-15T22:52:59.6870940Z Test Case '-[PointFreeTests.ChangeTests testChangeUpdateRemoveSeatsInvalidNumber]' passed (0.007 seconds).
2020-11-15T22:52:59.6873150Z Test Case '-[PointFreeTests.ChangeTests testChangeUpdateUpgradeIndividualPlan]' started.
2020-11-15T22:52:59.6909940Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 45D65333-9884-4718-AD90-66D7BB3C0A70 [Request] POST /account/subscription/change
2020-11-15T22:52:59.6933170Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 45D65333-9884-4718-AD90-66D7BB3C0A70 [Time] 2ms
2020-11-15T22:52:59.6939940Z Test Case '-[PointFreeTests.ChangeTests testChangeUpdateUpgradeIndividualPlan]' passed (0.007 seconds).
2020-11-15T22:52:59.6942050Z Test Case '-[PointFreeTests.ChangeTests testChangeUpdateUpgradeTeamPlan]' started.
2020-11-15T22:52:59.6972640Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 C54693E3-8294-407C-BF02-C93D43FB9127 [Request] POST /account/subscription/change
2020-11-15T22:52:59.6991900Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift C54693E3-8294-407C-BF02-C93D43FB9127 [Time] 1ms
2020-11-15T22:52:59.6998750Z Test Case '-[PointFreeTests.ChangeTests testChangeUpdateUpgradeTeamPlan]' passed (0.006 seconds).
2020-11-15T22:52:59.7001220Z Test Case '-[PointFreeTests.ChangeTests testChangeUpgradeIndividualMonthlyToTeamYearly]' started.
2020-11-15T22:52:59.7034460Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 6A5CC337-5371-4666-B833-014FFF5B137A [Request] POST /account/subscription/change
2020-11-15T22:52:59.7054090Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 6A5CC337-5371-4666-B833-014FFF5B137A [Time] 2ms
2020-11-15T22:52:59.7065870Z Test Case '-[PointFreeTests.ChangeTests testChangeUpgradeIndividualMonthlyToTeamYearly]' passed (0.006 seconds).
2020-11-15T22:52:59.7067460Z Test Suite 'ChangeTests' passed at 2020-11-15 22:52:59.706.
2020-11-15T22:52:59.7067910Z    Executed 10 tests, with 0 failures (0 unexpected) in 0.065 (0.066) seconds
2020-11-15T22:52:59.7068760Z Test Suite 'CollectionTests' started at 2020-11-15 22:52:59.706
2020-11-15T22:52:59.7069770Z Test Case '-[ModelsTests.CollectionTests testAllCollections]' started.
2020-11-15T22:52:59.7071050Z Test Case '-[ModelsTests.CollectionTests testAllCollections]' passed (0.001 seconds).
2020-11-15T22:52:59.7072390Z Test Suite 'CollectionTests' passed at 2020-11-15 22:52:59.707.
2020-11-15T22:52:59.7072890Z    Executed 1 test, with 0 failures (0 unexpected) in 0.001 (0.001) seconds
2020-11-15T22:52:59.7073770Z Test Suite 'CollectionsTests' started at 2020-11-15 22:52:59.707
2020-11-15T22:52:59.7074850Z Test Case '-[PointFreeTests.CollectionsTests testCollectionIndex]' started.
2020-11-15T22:52:59.7106290Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 9EC7FFAC-0D8A-4F71-8EAB-1B0FE3D6DC28 [Request] GET /collections
2020-11-15T22:52:59.7518580Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 9EC7FFAC-0D8A-4F71-8EAB-1B0FE3D6DC28 [Time] 41ms
2020-11-15T22:52:59.7530710Z Test Case '-[PointFreeTests.CollectionsTests testCollectionIndex]' passed (0.046 seconds).
2020-11-15T22:52:59.7532440Z Test Case '-[PointFreeTests.CollectionsTests testCollectionSection]' started.
2020-11-15T22:52:59.7568620Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 FCEF0A90-09C5-4EAB-85CE-882D54722AF0 [Request] GET /collections/functions/functions-that-begin-with-b
2020-11-15T22:52:59.8052310Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift FCEF0A90-09C5-4EAB-85CE-882D54722AF0 [Time] 48ms
2020-11-15T22:52:59.8062810Z Test Case '-[PointFreeTests.CollectionsTests testCollectionSection]' passed (0.053 seconds).
2020-11-15T22:52:59.8064590Z Test Case '-[PointFreeTests.CollectionsTests testCollectionShow]' started.
2020-11-15T22:52:59.8092170Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 1B3580C3-83B7-423C-8DCD-286103EC7801 [Request] GET /collections/functions
2020-11-15T22:52:59.8914980Z 2020-11-15T22:52:59+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 1B3580C3-83B7-423C-8DCD-286103EC7801 [Time] 82ms
2020-11-15T22:52:59.8964270Z Test Case '-[PointFreeTests.CollectionsTests testCollectionShow]' passed (0.087 seconds).
2020-11-15T22:52:59.8965490Z Test Suite 'CollectionsTests' passed at 2020-11-15 22:52:59.894.
2020-11-15T22:52:59.8977670Z    Executed 3 tests, with 0 failures (0 unexpected) in 0.187 (0.187) seconds
2020-11-15T22:52:59.8979420Z Test Suite 'DatabaseTests' started at 2020-11-15 22:52:59.894
2020-11-15T22:52:59.9081890Z Test Case '-[PointFreeTests.DatabaseTests testCreateSubscription_OwnerIsNotTakingSeat]' started.
2020-11-15T22:52:59.9183680Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:52:59.9204880Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:52:59.9209870Z drop cascades to extension uuid-ossp
2020-11-15T22:52:59.9241110Z drop cascades to extension citext
2020-11-15T22:52:59.9242380Z drop cascades to table users
2020-11-15T22:52:59.9248400Z drop cascades to table subscriptions
2020-11-15T22:52:59.9252980Z drop cascades to table team_invites
2020-11-15T22:52:59.9253890Z drop cascades to table email_settings
2020-11-15T22:52:59.9258020Z drop cascades to table episode_credits
2020-11-15T22:52:59.9258700Z drop cascades to table feed_request_events
2020-11-15T22:52:59.9259350Z drop cascades to function update_updated_at()
2020-11-15T22:52:59.9260000Z drop cascades to table enterprise_accounts
2020-11-15T22:52:59.9260510Z drop cascades to table enterprise_emails
2020-11-15T22:52:59.9261000Z drop cascades to table episode_progresses
2020-11-15T22:52:59.9261610Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:52:59.9262440Z drop cascades to sequence test_uuids
2020-11-15T22:52:59.9262940Z drop cascades to sequence test_shortids
2020-11-15T22:53:00.9327130Z Test Case '-[PointFreeTests.DatabaseTests testCreateSubscription_OwnerIsNotTakingSeat]' passed (1.039 seconds).
2020-11-15T22:53:00.9328970Z Test Case '-[PointFreeTests.DatabaseTests testCreateSubscription_OwnerIsTakingSeat]' started.
2020-11-15T22:53:00.9455450Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:00.9456000Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:00.9457160Z drop cascades to extension uuid-ossp
2020-11-15T22:53:00.9457550Z drop cascades to extension citext
2020-11-15T22:53:00.9457880Z drop cascades to table users
2020-11-15T22:53:00.9458240Z drop cascades to table subscriptions
2020-11-15T22:53:00.9458610Z drop cascades to table team_invites
2020-11-15T22:53:00.9459500Z drop cascades to table email_settings
2020-11-15T22:53:00.9459870Z drop cascades to table episode_credits
2020-11-15T22:53:00.9460230Z drop cascades to table feed_request_events
2020-11-15T22:53:00.9460620Z drop cascades to function update_updated_at()
2020-11-15T22:53:00.9461020Z drop cascades to table enterprise_accounts
2020-11-15T22:53:00.9461420Z drop cascades to table enterprise_emails
2020-11-15T22:53:00.9461800Z drop cascades to table episode_progresses
2020-11-15T22:53:00.9462210Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:00.9462580Z drop cascades to sequence test_uuids
2020-11-15T22:53:00.9462940Z drop cascades to sequence test_shortids
2020-11-15T22:53:02.0174470Z Test Case '-[PointFreeTests.DatabaseTests testCreateSubscription_OwnerIsTakingSeat]' passed (1.085 seconds).
2020-11-15T22:53:02.0177180Z Test Case '-[PointFreeTests.DatabaseTests testFetchEnterpriseAccount]' started.
2020-11-15T22:53:02.0304780Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:02.0305300Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:02.0306510Z drop cascades to extension uuid-ossp
2020-11-15T22:53:02.0306890Z drop cascades to extension citext
2020-11-15T22:53:02.0307230Z drop cascades to table users
2020-11-15T22:53:02.0307570Z drop cascades to table subscriptions
2020-11-15T22:53:02.0307950Z drop cascades to table team_invites
2020-11-15T22:53:02.0308310Z drop cascades to table email_settings
2020-11-15T22:53:02.0308680Z drop cascades to table episode_credits
2020-11-15T22:53:02.0309050Z drop cascades to table feed_request_events
2020-11-15T22:53:02.0309450Z drop cascades to function update_updated_at()
2020-11-15T22:53:02.0309850Z drop cascades to table enterprise_accounts
2020-11-15T22:53:02.0310240Z drop cascades to table enterprise_emails
2020-11-15T22:53:02.0310640Z drop cascades to table episode_progresses
2020-11-15T22:53:02.0311050Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:02.0311450Z drop cascades to sequence test_uuids
2020-11-15T22:53:02.0311820Z drop cascades to sequence test_shortids
2020-11-15T22:53:03.2423680Z Test Case '-[PointFreeTests.DatabaseTests testFetchEnterpriseAccount]' passed (1.225 seconds).
2020-11-15T22:53:03.2425910Z Test Case '-[PointFreeTests.DatabaseTests testFetchEpisodeProgress_NoProgress]' started.
2020-11-15T22:53:03.2567960Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:03.2568510Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:03.2569730Z drop cascades to extension uuid-ossp
2020-11-15T22:53:03.2570110Z drop cascades to extension citext
2020-11-15T22:53:03.2570450Z drop cascades to table users
2020-11-15T22:53:03.2570800Z drop cascades to table subscriptions
2020-11-15T22:53:03.2571160Z drop cascades to table team_invites
2020-11-15T22:53:03.2571520Z drop cascades to table email_settings
2020-11-15T22:53:03.2571890Z drop cascades to table episode_credits
2020-11-15T22:53:03.2572260Z drop cascades to table feed_request_events
2020-11-15T22:53:03.2572670Z drop cascades to function update_updated_at()
2020-11-15T22:53:03.2573080Z drop cascades to table enterprise_accounts
2020-11-15T22:53:03.2573480Z drop cascades to table enterprise_emails
2020-11-15T22:53:03.2573860Z drop cascades to table episode_progresses
2020-11-15T22:53:03.2574290Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:03.2575120Z drop cascades to sequence test_uuids
2020-11-15T22:53:03.2575530Z drop cascades to sequence test_shortids
2020-11-15T22:53:04.2970790Z Test Case '-[PointFreeTests.DatabaseTests testFetchEpisodeProgress_NoProgress]' passed (1.055 seconds).
2020-11-15T22:53:04.2972390Z Test Case '-[PointFreeTests.DatabaseTests testFetchEpisodeProgress]' started.
2020-11-15T22:53:04.3104830Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:04.3105370Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:04.3106570Z drop cascades to extension uuid-ossp
2020-11-15T22:53:04.3106960Z drop cascades to extension citext
2020-11-15T22:53:04.3107790Z drop cascades to table users
2020-11-15T22:53:04.3108140Z drop cascades to table subscriptions
2020-11-15T22:53:04.3108520Z drop cascades to table team_invites
2020-11-15T22:53:04.3108860Z drop cascades to table email_settings
2020-11-15T22:53:04.3109230Z drop cascades to table episode_credits
2020-11-15T22:53:04.3109600Z drop cascades to table feed_request_events
2020-11-15T22:53:04.3110010Z drop cascades to function update_updated_at()
2020-11-15T22:53:04.3110420Z drop cascades to table enterprise_accounts
2020-11-15T22:53:04.3110950Z drop cascades to table enterprise_emails
2020-11-15T22:53:04.3111360Z drop cascades to table episode_progresses
2020-11-15T22:53:04.3111770Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:04.3112160Z drop cascades to sequence test_uuids
2020-11-15T22:53:04.3112530Z drop cascades to sequence test_shortids
2020-11-15T22:53:05.3632500Z Test Case '-[PointFreeTests.DatabaseTests testFetchEpisodeProgress]' passed (1.066 seconds).
2020-11-15T22:53:05.3634400Z Test Case '-[PointFreeTests.DatabaseTests testUpdateEpisodeProgress]' started.
2020-11-15T22:53:05.3766850Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:05.3767640Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:05.3769100Z drop cascades to extension uuid-ossp
2020-11-15T22:53:05.3769690Z drop cascades to extension citext
2020-11-15T22:53:05.3770220Z drop cascades to table users
2020-11-15T22:53:05.3770750Z drop cascades to table subscriptions
2020-11-15T22:53:05.3771280Z drop cascades to table team_invites
2020-11-15T22:53:05.3771800Z drop cascades to table email_settings
2020-11-15T22:53:05.3772330Z drop cascades to table episode_credits
2020-11-15T22:53:05.3772880Z drop cascades to table feed_request_events
2020-11-15T22:53:05.3773440Z drop cascades to function update_updated_at()
2020-11-15T22:53:05.3774010Z drop cascades to table enterprise_accounts
2020-11-15T22:53:05.3774570Z drop cascades to table enterprise_emails
2020-11-15T22:53:05.3775130Z drop cascades to table episode_progresses
2020-11-15T22:53:05.3775720Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:05.3776280Z drop cascades to sequence test_uuids
2020-11-15T22:53:05.3776800Z drop cascades to sequence test_shortids
2020-11-15T22:53:06.5725910Z Test Case '-[PointFreeTests.DatabaseTests testUpdateEpisodeProgress]' passed (1.209 seconds).
2020-11-15T22:53:06.5727780Z Test Case '-[PointFreeTests.DatabaseTests testUpsertUser_FetchUserById]' started.
2020-11-15T22:53:06.5856580Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:06.5857310Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:06.5858770Z drop cascades to extension uuid-ossp
2020-11-15T22:53:06.5859160Z drop cascades to extension citext
2020-11-15T22:53:06.5859610Z drop cascades to table users
2020-11-15T22:53:06.5860270Z drop cascades to table subscriptions
2020-11-15T22:53:06.5860840Z drop cascades to table team_invites
2020-11-15T22:53:06.5861380Z drop cascades to table email_settings
2020-11-15T22:53:06.5861930Z drop cascades to table episode_credits
2020-11-15T22:53:06.5862510Z drop cascades to table feed_request_events
2020-11-15T22:53:06.5863090Z drop cascades to function update_updated_at()
2020-11-15T22:53:06.5863670Z drop cascades to table enterprise_accounts
2020-11-15T22:53:06.5864260Z drop cascades to table enterprise_emails
2020-11-15T22:53:06.5865200Z drop cascades to table episode_progresses
2020-11-15T22:53:06.5865880Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:06.5866460Z drop cascades to sequence test_uuids
2020-11-15T22:53:06.5867020Z drop cascades to sequence test_shortids
2020-11-15T22:53:07.4631700Z Test Case '-[PointFreeTests.DatabaseTests testUpsertUser_FetchUserById]' passed (0.891 seconds).
2020-11-15T22:53:07.4632920Z Test Suite 'DatabaseTests' passed at 2020-11-15 22:53:07.463.
2020-11-15T22:53:07.4633380Z    Executed 7 tests, with 0 failures (0 unexpected) in 7.569 (7.569) seconds
2020-11-15T22:53:07.4634190Z Test Suite 'DiscountsTests' started at 2020-11-15 22:53:07.463
2020-11-15T22:53:07.4635700Z Test Case '-[PointFreeTests.DiscountsTests testDiscounts_LoggedIn_5DollarsOff_Forever]' started.
2020-11-15T22:53:07.4654380Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 74EE5FA9-94C2-492B-922C-68621E5E9EA3 [Request] GET /discounts/blobfest
2020-11-15T22:53:07.5096000Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 74EE5FA9-94C2-492B-922C-68621E5E9EA3 [Time] 44ms
2020-11-15T22:53:07.5104140Z Test Case '-[PointFreeTests.DiscountsTests testDiscounts_LoggedIn_5DollarsOff_Forever]' passed (0.047 seconds).
2020-11-15T22:53:07.5105630Z Test Case '-[PointFreeTests.DiscountsTests testDiscounts_LoggedIn_5DollarsOff_Once]' started.
2020-11-15T22:53:07.5124520Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 9C5E7548-D0FD-4B08-929D-AB5CC4B1F5EA [Request] GET /discounts/blobfest
2020-11-15T22:53:07.5496710Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 9C5E7548-D0FD-4B08-929D-AB5CC4B1F5EA [Time] 37ms
2020-11-15T22:53:07.5505210Z Test Case '-[PointFreeTests.DiscountsTests testDiscounts_LoggedIn_5DollarsOff_Once]' passed (0.040 seconds).
2020-11-15T22:53:07.5506740Z Test Case '-[PointFreeTests.DiscountsTests testDiscounts_LoggedIn_5DollarsOff_Repeating]' started.
2020-11-15T22:53:07.5525560Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 E62BAB02-0A27-4111-90FC-5C0627C8E14B [Request] GET /discounts/blobfest
2020-11-15T22:53:07.5910860Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 E62BAB02-0A27-4111-90FC-5C0627C8E14B [Time] 38ms
2020-11-15T22:53:07.5918900Z Test Case '-[PointFreeTests.DiscountsTests testDiscounts_LoggedIn_5DollarsOff_Repeating]' passed (0.041 seconds).
2020-11-15T22:53:07.5920530Z Test Case '-[PointFreeTests.DiscountsTests testDiscounts_LoggedIn_PercentOff_Forever]' started.
2020-11-15T22:53:07.5937860Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift D9ECE82A-5BC0-4CB6-92A0-5E619D27AE77 [Request] GET /discounts/blobfest
2020-11-15T22:53:07.6326530Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift D9ECE82A-5BC0-4CB6-92A0-5E619D27AE77 [Time] 38ms
2020-11-15T22:53:07.6437240Z Test Case '-[PointFreeTests.DiscountsTests testDiscounts_LoggedIn_PercentOff_Forever]' passed (0.042 seconds).
2020-11-15T22:53:07.6439470Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 DB34E2F0-7317-45F1-AE03-EAB3450B59EF [Request] GET /discounts/blobfest
2020-11-15T22:53:07.6441500Z Test Case '-[PointFreeTests.DiscountsTests testDiscounts_LoggedIn_PercentOff_Once]' started.
2020-11-15T22:53:07.6807570Z Test Case '-[PointFreeTests.DiscountsTests testDiscounts_LoggedIn_PercentOff_Once]' passed (0.046 seconds).
2020-11-15T22:53:07.6810360Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift DB34E2F0-7317-45F1-AE03-EAB3450B59EF [Time] 42ms
2020-11-15T22:53:07.6818980Z Test Case '-[PointFreeTests.DiscountsTests testDiscounts_LoggedIn_PercentOff_Repeating]' started.
2020-11-15T22:53:07.6821020Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 09D4C8FD-C363-43BD-8A13-6B41C8EB20DF [Request] GET /discounts/blobfest
2020-11-15T22:53:07.7220320Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 09D4C8FD-C363-43BD-8A13-6B41C8EB20DF [Time] 40ms
2020-11-15T22:53:07.7228200Z Test Case '-[PointFreeTests.DiscountsTests testDiscounts_LoggedIn_PercentOff_Repeating]' passed (0.043 seconds).
2020-11-15T22:53:07.7230050Z Test Case '-[PointFreeTests.DiscountsTests testDiscounts_LoggedOut]' started.
2020-11-15T22:53:07.7251120Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 56157898-6AE6-4D04-8AAA-1D4C3AE60BD0 [Request] GET /discounts/blobfest
2020-11-15T22:53:07.7717430Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 56157898-6AE6-4D04-8AAA-1D4C3AE60BD0 [Time] 46ms
2020-11-15T22:53:07.7819600Z Test Case '-[PointFreeTests.DiscountsTests testDiscounts_LoggedOut]' passed (0.050 seconds).
2020-11-15T22:53:07.7822180Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 4C53416A-616F-4DFB-8B14-03EF5D9E9D75 [Request] GET /discounts/regional-discount
2020-11-15T22:53:07.7831370Z Test Case '-[PointFreeTests.DiscountsTests testDiscounts_UsingRegionalCouponId]' started.
2020-11-15T22:53:07.7833360Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 4C53416A-616F-4DFB-8B14-03EF5D9E9D75 [Time] 1ms
2020-11-15T22:53:07.7836550Z Test Case '-[PointFreeTests.DiscountsTests testDiscounts_UsingRegionalCouponId]' passed (0.003 seconds).
2020-11-15T22:53:07.7897200Z Test Suite 'DiscountsTests' passed at 2020-11-15 22:53:07.776.
2020-11-15T22:53:07.7901220Z    Executed 8 tests, with 0 failures (0 unexpected) in 0.313 (0.313) seconds
2020-11-15T22:53:07.7902500Z Test Suite 'EitherIOTests' started at 2020-11-15 22:53:07.776
2020-11-15T22:53:07.7906000Z Test Case '-[PointFreeTests.EitherIOTests testRetry_Fails]' started.
2020-11-15T22:53:07.7910850Z Test Case '-[PointFreeTests.EitherIOTests testRetry_Fails]' passed (0.002 seconds).
2020-11-15T22:53:07.7914570Z Test Case '-[PointFreeTests.EitherIOTests testRetry_MaxRetriesZero_Failure]' started.
2020-11-15T22:53:07.7916170Z Test Case '-[PointFreeTests.EitherIOTests testRetry_MaxRetriesZero_Failure]' passed (0.001 seconds).
2020-11-15T22:53:07.7917530Z Test Case '-[PointFreeTests.EitherIOTests testRetry_MaxRetriesZero_Success]' started.
2020-11-15T22:53:07.7918880Z Test Case '-[PointFreeTests.EitherIOTests testRetry_MaxRetriesZero_Success]' passed (0.001 seconds).
2020-11-15T22:53:07.7920130Z Test Case '-[PointFreeTests.EitherIOTests testRetry_Succeeds]' started.
2020-11-15T22:53:07.7921330Z Test Case '-[PointFreeTests.EitherIOTests testRetry_Succeeds]' passed (0.002 seconds).
2020-11-15T22:53:07.7922310Z Test Suite 'EitherIOTests' passed at 2020-11-15 22:53:07.782.
2020-11-15T22:53:07.7922780Z    Executed 4 tests, with 0 failures (0 unexpected) in 0.006 (0.006) seconds
2020-11-15T22:53:07.7923870Z Test Suite 'EmailInviteTests' started at 2020-11-15 22:53:07.783
2020-11-15T22:53:07.7925000Z Test Case '-[PointFreeTests.EmailInviteTests testEmailInvite]' started.
2020-11-15T22:53:07.8329400Z Test Case '-[PointFreeTests.EmailInviteTests testEmailInvite]' passed (0.050 seconds).
2020-11-15T22:53:07.8364010Z Test Case '-[PointFreeTests.EmailInviteTests testInviteAcceptance]' started.
2020-11-15T22:53:07.8770750Z Test Case '-[PointFreeTests.EmailInviteTests testInviteAcceptance]' passed (0.044 seconds).
2020-11-15T22:53:07.8778640Z Test Suite 'EmailInviteTests' passed at 2020-11-15 22:53:07.877.
2020-11-15T22:53:07.8792380Z    Executed 2 tests, with 0 failures (0 unexpected) in 0.094 (0.094) seconds
2020-11-15T22:53:07.8794160Z Test Suite 'EnterpriseTests' started at 2020-11-15 22:53:07.877
2020-11-15T22:53:07.8795330Z Test Case '-[PointFreeTests.EnterpriseTests testAcceptInvitation_BadEmail]' started.
2020-11-15T22:53:07.8821440Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 DEED92C1-BA68-4C1D-B0C5-9DB2B9DA44A5 [Request] GET /enterprise/pointfree.co/accept
2020-11-15T22:53:07.8853450Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift DEED92C1-BA68-4C1D-B0C5-9DB2B9DA44A5 [Time] 3ms
2020-11-15T22:53:07.8859140Z Test Case '-[PointFreeTests.EnterpriseTests testAcceptInvitation_BadEmail]' passed (0.009 seconds).
2020-11-15T22:53:07.8864610Z Test Case '-[PointFreeTests.EnterpriseTests testAcceptInvitation_BadUserId]' started.
2020-11-15T22:53:07.8900670Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 923EA30D-6C73-467B-99EF-C5324C9EDC23 [Request] GET /enterprise/pointfree.co/accept
2020-11-15T22:53:07.8932110Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 923EA30D-6C73-467B-99EF-C5324C9EDC23 [Time] 3ms
2020-11-15T22:53:07.8944680Z Test Case '-[PointFreeTests.EnterpriseTests testAcceptInvitation_BadUserId]' passed (0.008 seconds).
2020-11-15T22:53:07.8960510Z Test Case '-[PointFreeTests.EnterpriseTests testAcceptInvitation_EmailDoesntMatchEnterpriseDomain]' started.
2020-11-15T22:53:07.8988760Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 3B5F1F62-C060-475D-A554-AE05EE0F241D [Request] GET /enterprise/pointfree.co/accept
2020-11-15T22:53:07.9013300Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 3B5F1F62-C060-475D-A554-AE05EE0F241D [Time] 2ms
2020-11-15T22:53:07.9019870Z Test Case '-[PointFreeTests.EnterpriseTests testAcceptInvitation_EmailDoesntMatchEnterpriseDomain]' passed (0.008 seconds).
2020-11-15T22:53:07.9024700Z Test Case '-[PointFreeTests.EnterpriseTests testAcceptInvitation_EnterpriseAccountDoesntExist]' started.
2020-11-15T22:53:07.9066460Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 3492A11E-3325-471D-802D-C7E7D1F41683 [Request] GET /enterprise/pointfree.co/accept
2020-11-15T22:53:07.9080910Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 3492A11E-3325-471D-802D-C7E7D1F41683 [Time] 1ms
2020-11-15T22:53:07.9089960Z Test Case '-[PointFreeTests.EnterpriseTests testAcceptInvitation_EnterpriseAccountDoesntExist]' passed (0.007 seconds).
2020-11-15T22:53:07.9091930Z Test Case '-[PointFreeTests.EnterpriseTests testAcceptInvitation_HappyPath]' started.
2020-11-15T22:53:07.9137720Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 CBD4AED7-F7FB-473E-AAF3-6B4A76B7012B [Request] GET /enterprise/pointfree.co/accept
2020-11-15T22:53:07.9164170Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 CBD4AED7-F7FB-473E-AAF3-6B4A76B7012B [Time] 2ms
2020-11-15T22:53:07.9170350Z Test Case '-[PointFreeTests.EnterpriseTests testAcceptInvitation_HappyPath]' passed (0.008 seconds).
2020-11-15T22:53:07.9176330Z Test Case '-[PointFreeTests.EnterpriseTests testAcceptInvitation_LoggedOut]' started.
2020-11-15T22:53:07.9204160Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 39B4B7CE-3678-407B-8450-190434C6CA56 [Request] GET /enterprise/blob.biz/accept
2020-11-15T22:53:07.9232450Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 39B4B7CE-3678-407B-8450-190434C6CA56 [Time] 2ms
2020-11-15T22:53:07.9240540Z Test Case '-[PointFreeTests.EnterpriseTests testAcceptInvitation_LoggedOut]' passed (0.007 seconds).
2020-11-15T22:53:07.9244020Z Test Case '-[PointFreeTests.EnterpriseTests testAcceptInvitation_RequesterUserDoesntMatchAccepterUserId]' started.
2020-11-15T22:53:07.9295440Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 BBB27205-3A6F-4DE3-95C8-3DAA16DA4F79 [Request] GET /enterprise/pointfree.co/accept
2020-11-15T22:53:07.9405030Z Test Case '-[PointFreeTests.EnterpriseTests testAcceptInvitation_RequesterUserDoesntMatchAccepterUserId]' passed (0.010 seconds).
2020-11-15T22:53:07.9407450Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift BBB27205-3A6F-4DE3-95C8-3DAA16DA4F79 [Time] 3ms
2020-11-15T22:53:07.9410850Z Test Case '-[PointFreeTests.EnterpriseTests testLanding_AlreadySubscribedToEnterprise]' started.
2020-11-15T22:53:07.9419360Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 5790FE95-187F-4B6B-BFFE-97364B4CC9DF [Request] GET /enterprise/blob.biz
2020-11-15T22:53:07.9738210Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 5790FE95-187F-4B6B-BFFE-97364B4CC9DF [Time] 35ms
2020-11-15T22:53:07.9744410Z Test Case '-[PointFreeTests.EnterpriseTests testLanding_AlreadySubscribedToEnterprise]' passed (0.040 seconds).
2020-11-15T22:53:07.9746420Z Test Case '-[PointFreeTests.EnterpriseTests testLanding_LoggedOut]' started.
2020-11-15T22:53:07.9784110Z 2020-11-15T22:53:07+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 60E2D94B-575E-4096-AA17-AE3ECC63B758 [Request] GET /enterprise/blob.biz
2020-11-15T22:53:08.0130660Z 2020-11-15T22:53:08+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 60E2D94B-575E-4096-AA17-AE3ECC63B758 [Time] 35ms
2020-11-15T22:53:08.0141070Z Test Case '-[PointFreeTests.EnterpriseTests testLanding_LoggedOut]' passed (0.040 seconds).
2020-11-15T22:53:08.0142630Z Test Case '-[PointFreeTests.EnterpriseTests testLanding_NonExistentEnterpriseAccount]' started.
2020-11-15T22:53:08.0171450Z 2020-11-15T22:53:08+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift C0968921-1618-45FD-9DD9-6DBF282B2EB8 [Request] GET /enterprise/blob.biz
2020-11-15T22:53:08.0182880Z 2020-11-15T22:53:08+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift C0968921-1618-45FD-9DD9-6DBF282B2EB8 [Time] 1ms
2020-11-15T22:53:08.0189730Z Test Case '-[PointFreeTests.EnterpriseTests testLanding_NonExistentEnterpriseAccount]' passed (0.005 seconds).
2020-11-15T22:53:08.0191090Z Test Suite 'EnterpriseTests' passed at 2020-11-15 22:53:08.019.
2020-11-15T22:53:08.0191700Z    Executed 10 tests, with 0 failures (0 unexpected) in 0.141 (0.142) seconds
2020-11-15T22:53:08.0193040Z Test Suite 'EnvVarTests' started at 2020-11-15 22:53:08.019
2020-11-15T22:53:08.0193970Z Test Case '-[PointFreeTests.EnvVarTests testDecoding]' started.
2020-11-15T22:53:08.0226490Z Test Case '-[PointFreeTests.EnvVarTests testDecoding]' passed (0.004 seconds).
2020-11-15T22:53:08.0228080Z Test Suite 'EnvVarTests' passed at 2020-11-15 22:53:08.023.
2020-11-15T22:53:08.0228550Z    Executed 1 test, with 0 failures (0 unexpected) in 0.004 (0.004) seconds
2020-11-15T22:53:08.0229430Z Test Suite 'EnvironmentTests' started at 2020-11-15 22:53:08.023
2020-11-15T22:53:08.0230640Z Test Case '-[PointFreeTests.EnvironmentTests testDefault]' started.
2020-11-15T22:53:08.0244880Z Test Case '-[PointFreeTests.EnvironmentTests testDefault]' passed (0.002 seconds).
2020-11-15T22:53:08.0246180Z Test Suite 'EnvironmentTests' passed at 2020-11-15 22:53:08.024.
2020-11-15T22:53:08.0246670Z    Executed 1 test, with 0 failures (0 unexpected) in 0.002 (0.002) seconds
2020-11-15T22:53:08.0247740Z Test Suite 'EpisodePageIntegrationTests' started at 2020-11-15 22:53:08.024
2020-11-15T22:53:08.0249340Z Test Case '-[PointFreeTests.EpisodePageIntegrationTests testRedeemEpisodeCredit_AlreadyCredited]' started.
2020-11-15T22:53:08.0380080Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:08.0380590Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:08.0381710Z drop cascades to extension uuid-ossp
2020-11-15T22:53:08.0382080Z drop cascades to extension citext
2020-11-15T22:53:08.0382410Z drop cascades to table users
2020-11-15T22:53:08.0382790Z drop cascades to table subscriptions
2020-11-15T22:53:08.0383160Z drop cascades to table team_invites
2020-11-15T22:53:08.0383510Z drop cascades to table email_settings
2020-11-15T22:53:08.0383880Z drop cascades to table episode_credits
2020-11-15T22:53:08.0384260Z drop cascades to table feed_request_events
2020-11-15T22:53:08.0384640Z drop cascades to function update_updated_at()
2020-11-15T22:53:08.0385140Z drop cascades to table enterprise_accounts
2020-11-15T22:53:08.0385620Z drop cascades to table enterprise_emails
2020-11-15T22:53:08.0386020Z drop cascades to table episode_progresses
2020-11-15T22:53:08.0386430Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:08.0386840Z drop cascades to sequence test_uuids
2020-11-15T22:53:08.0387200Z drop cascades to sequence test_shortids
2020-11-15T22:53:09.1314940Z 2020-11-15T22:53:09+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 6F3F6519-3827-4B17-915C-78A7A4478E57 [Request] POST /episodes/2/credit
2020-11-15T22:53:09.1566540Z 2020-11-15T22:53:09+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 6F3F6519-3827-4B17-915C-78A7A4478E57 [Time] 24ms
2020-11-15T22:53:09.1796300Z Test Case '-[PointFreeTests.EpisodePageIntegrationTests testRedeemEpisodeCredit_AlreadyCredited]' passed (1.152 seconds).
2020-11-15T22:53:09.1798370Z Test Case '-[PointFreeTests.EpisodePageIntegrationTests testRedeemEpisodeCredit_HappyPath]' started.
2020-11-15T22:53:09.1953750Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:09.1961770Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:09.1966030Z drop cascades to extension uuid-ossp
2020-11-15T22:53:09.1966460Z drop cascades to extension citext
2020-11-15T22:53:09.1966800Z drop cascades to table users
2020-11-15T22:53:09.1967150Z drop cascades to table subscriptions
2020-11-15T22:53:09.1967920Z drop cascades to table team_invites
2020-11-15T22:53:09.1968320Z drop cascades to table email_settings
2020-11-15T22:53:09.1968690Z drop cascades to table episode_credits
2020-11-15T22:53:09.1969050Z drop cascades to table feed_request_events
2020-11-15T22:53:09.1969450Z drop cascades to function update_updated_at()
2020-11-15T22:53:09.1969860Z drop cascades to table enterprise_accounts
2020-11-15T22:53:09.1970260Z drop cascades to table enterprise_emails
2020-11-15T22:53:09.1970650Z drop cascades to table episode_progresses
2020-11-15T22:53:09.1971070Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:09.1971460Z drop cascades to sequence test_uuids
2020-11-15T22:53:09.1972050Z drop cascades to sequence test_shortids
2020-11-15T22:53:10.3834150Z 2020-11-15T22:53:10+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 0CD00D92-FD14-4EF1-A905-ABC5C8925FF8 [Request] POST /episodes/2/credit
2020-11-15T22:53:10.4536270Z 2020-11-15T22:53:10+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 0CD00D92-FD14-4EF1-A905-ABC5C8925FF8 [Time] 70ms
2020-11-15T22:53:10.4656750Z Test Case '-[PointFreeTests.EpisodePageIntegrationTests testRedeemEpisodeCredit_HappyPath]' passed (1.287 seconds).
2020-11-15T22:53:10.4659310Z Test Case '-[PointFreeTests.EpisodePageIntegrationTests testRedeemEpisodeCredit_NotEnoughCredits]' started.
2020-11-15T22:53:10.4787130Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:10.4787620Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:10.4788860Z drop cascades to extension uuid-ossp
2020-11-15T22:53:10.4789240Z drop cascades to extension citext
2020-11-15T22:53:10.4789560Z drop cascades to table users
2020-11-15T22:53:10.4789990Z drop cascades to table subscriptions
2020-11-15T22:53:10.4790360Z drop cascades to table team_invites
2020-11-15T22:53:10.4790700Z drop cascades to table email_settings
2020-11-15T22:53:10.4791060Z drop cascades to table episode_credits
2020-11-15T22:53:10.4791430Z drop cascades to table feed_request_events
2020-11-15T22:53:10.4791820Z drop cascades to function update_updated_at()
2020-11-15T22:53:10.4792210Z drop cascades to table enterprise_accounts
2020-11-15T22:53:10.4792610Z drop cascades to table enterprise_emails
2020-11-15T22:53:10.4792990Z drop cascades to table episode_progresses
2020-11-15T22:53:10.4793390Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:10.4793770Z drop cascades to sequence test_uuids
2020-11-15T22:53:10.4794130Z drop cascades to sequence test_shortids
2020-11-15T22:53:11.3347690Z 2020-11-15T22:53:11+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 7B0ED2E2-4CB4-435E-A265-9C831009BC7E [Request] POST /episodes/2/credit
2020-11-15T22:53:11.3551330Z 2020-11-15T22:53:11+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 7B0ED2E2-4CB4-435E-A265-9C831009BC7E [Time] 20ms
2020-11-15T22:53:11.3611930Z Test Case '-[PointFreeTests.EpisodePageIntegrationTests testRedeemEpisodeCredit_NotEnoughCredits]' passed (0.895 seconds).
2020-11-15T22:53:11.3614010Z Test Case '-[PointFreeTests.EpisodePageIntegrationTests testRedeemEpisodeCredit_PublicEpisode]' started.
2020-11-15T22:53:11.3743680Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:11.3744200Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:11.3745310Z drop cascades to extension uuid-ossp
2020-11-15T22:53:11.3745690Z drop cascades to extension citext
2020-11-15T22:53:11.3746040Z drop cascades to table users
2020-11-15T22:53:11.3746390Z drop cascades to table subscriptions
2020-11-15T22:53:11.3746760Z drop cascades to table team_invites
2020-11-15T22:53:11.3747340Z drop cascades to table email_settings
2020-11-15T22:53:11.3747700Z drop cascades to table episode_credits
2020-11-15T22:53:11.3748450Z drop cascades to table feed_request_events
2020-11-15T22:53:11.3748890Z drop cascades to function update_updated_at()
2020-11-15T22:53:11.3749300Z drop cascades to table enterprise_accounts
2020-11-15T22:53:11.3749690Z drop cascades to table enterprise_emails
2020-11-15T22:53:11.3750090Z drop cascades to table episode_progresses
2020-11-15T22:53:11.3750510Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:11.3750900Z drop cascades to sequence test_uuids
2020-11-15T22:53:11.3751270Z drop cascades to sequence test_shortids
2020-11-15T22:53:12.4045040Z 2020-11-15T22:53:12+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 8A85D4F6-1080-4AF7-9DBD-B70071C0E67F [Request] POST /episodes/2/credit
2020-11-15T22:53:12.4266200Z 2020-11-15T22:53:12+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 8A85D4F6-1080-4AF7-9DBD-B70071C0E67F [Time] 22ms
2020-11-15T22:53:12.4330070Z Test Case '-[PointFreeTests.EpisodePageIntegrationTests testRedeemEpisodeCredit_PublicEpisode]' passed (1.072 seconds).
2020-11-15T22:53:12.4331700Z Test Suite 'EpisodePageIntegrationTests' passed at 2020-11-15 22:53:12.433.
2020-11-15T22:53:12.4332290Z    Executed 4 tests, with 0 failures (0 unexpected) in 4.407 (4.408) seconds
2020-11-15T22:53:12.4333130Z Test Suite 'EpisodePageTests' started at 2020-11-15 22:53:12.433
2020-11-15T22:53:12.4334140Z Test Case '-[PointFreeTests.EpisodePageTests test_permission]' started.
2020-11-15T22:53:12.4346590Z Test Case '-[PointFreeTests.EpisodePageTests test_permission]' passed (0.002 seconds).
2020-11-15T22:53:12.4348360Z Test Case '-[PointFreeTests.EpisodePageTests testEpisodeCredit_PrivateEpisode_NonSubscriber_HasCredits]' started.
2020-11-15T22:53:12.4376130Z 2020-11-15T22:53:12+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 F5A48625-5574-4B16-B7B2-43E240F8F3DE [Request] GET /episodes/ep2-proof-in-functions
2020-11-15T22:53:13.1126570Z Test Case '-[PointFreeTests.EpisodePageTests testEpisodeCredit_PrivateEpisode_NonSubscriber_HasCredits]' passed (0.044 seconds).
2020-11-15T22:53:13.1129180Z 2020-11-15T22:53:12+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift F5A48625-5574-4B16-B7B2-43E240F8F3DE [Time] 39ms
2020-11-15T22:53:13.1132430Z Test Case '-[PointFreeTests.EpisodePageTests testEpisodeCredit_PrivateEpisode_NonSubscriber_NoCredits]' started.
2020-11-15T22:53:13.1134170Z Test Case '-[PointFreeTests.EpisodePageTests testEpisodeCredit_PrivateEpisode_NonSubscriber_NoCredits]' passed (0.042 seconds).
2020-11-15T22:53:13.1135900Z Test Case '-[PointFreeTests.EpisodePageTests testEpisodeCredit_PrivateEpisode_NonSubscriber_UsedCredit]' started.
2020-11-15T22:53:13.1137600Z Test Case '-[PointFreeTests.EpisodePageTests testEpisodeCredit_PrivateEpisode_NonSubscriber_UsedCredit]' passed (0.045 seconds).
2020-11-15T22:53:13.1139290Z Test Case '-[PointFreeTests.EpisodePageTests testEpisodeCredit_PublicEpisode_NonSubscriber_UsedCredit]' started.
2020-11-15T22:53:13.1140970Z Test Case '-[PointFreeTests.EpisodePageTests testEpisodeCredit_PublicEpisode_NonSubscriber_UsedCredit]' passed (0.048 seconds).
2020-11-15T22:53:13.1142470Z Test Case '-[PointFreeTests.EpisodePageTests testEpisodeNotFound]' started.
2020-11-15T22:53:13.1144100Z Test Case '-[PointFreeTests.EpisodePageTests testEpisodeNotFound]' passed (0.035 seconds).
2020-11-15T22:53:13.1145700Z Test Case '-[PointFreeTests.EpisodePageTests testEpisodePage]' started.
2020-11-15T22:53:13.1147720Z Test Case '-[PointFreeTests.EpisodePageTests testEpisodePage]' passed (0.064 seconds).
2020-11-15T22:53:13.1149190Z Test Case '-[PointFreeTests.EpisodePageTests testEpisodePage_ExercisesAndReferences]' started.
2020-11-15T22:53:13.1151100Z Test Case '-[PointFreeTests.EpisodePageTests testEpisodePage_ExercisesAndReferences]' passed (0.042 seconds).
2020-11-15T22:53:13.1152750Z Test Case '-[PointFreeTests.EpisodePageTests testEpisodePage_InCollectionContext]' started.
2020-11-15T22:53:13.1154280Z Test Case '-[PointFreeTests.EpisodePageTests testEpisodePage_InCollectionContext]' passed (0.057 seconds).
2020-11-15T22:53:13.1155850Z Test Case '-[PointFreeTests.EpisodePageTests testEpisodePage_InCollectionContext_LastEpisode]' started.
2020-11-15T22:53:13.1157490Z Test Case '-[PointFreeTests.EpisodePageTests testEpisodePage_InCollectionContext_LastEpisode]' passed (0.061 seconds).
2020-11-15T22:53:13.1158970Z Test Case '-[PointFreeTests.EpisodePageTests testEpisodePage_Trialing]' started.
2020-11-15T22:53:13.1160610Z Test Case '-[PointFreeTests.EpisodePageTests testEpisodePage_Trialing]' passed (0.044 seconds).
2020-11-15T22:53:13.1162060Z Test Case '-[PointFreeTests.EpisodePageTests testEpisodePage_WithEpisodeProgress]' started.
2020-11-15T22:53:13.1163610Z Test Case '-[PointFreeTests.EpisodePageTests testEpisodePage_WithEpisodeProgress]' passed (0.045 seconds).
2020-11-15T22:53:13.1165110Z Test Case '-[PointFreeTests.EpisodePageTests testEpisodePageSubscriber]' started.
2020-11-15T22:53:13.1166620Z Test Case '-[PointFreeTests.EpisodePageTests testEpisodePageSubscriber]' passed (0.044 seconds).
2020-11-15T22:53:13.1168170Z Test Case '-[PointFreeTests.EpisodePageTests testEpisodePageSubscriber_Deactivated]' started.
2020-11-15T22:53:13.1169770Z Test Case '-[PointFreeTests.EpisodePageTests testEpisodePageSubscriber_Deactivated]' passed (0.045 seconds).
2020-11-15T22:53:13.1171240Z Test Case '-[PointFreeTests.EpisodePageTests testFreeEpisodePage]' started.
2020-11-15T22:53:13.1172620Z Test Case '-[PointFreeTests.EpisodePageTests testFreeEpisodePage]' passed (0.053 seconds).
2020-11-15T22:53:13.1174100Z Test Case '-[PointFreeTests.EpisodePageTests testFreeEpisodePageSubscriber]' started.
2020-11-15T22:53:13.1176270Z 2020-11-15T22:53:12+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 35D52D93-9499-45D7-8DAD-0DC8DDFACF77 [Request] GET /episodes/ep2-proof-in-functions
2020-11-15T22:53:13.1178680Z 2020-11-15T22:53:12+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 35D52D93-9499-45D7-8DAD-0DC8DDFACF77 [Time] 37ms
2020-11-15T22:53:13.1181070Z 2020-11-15T22:53:12+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift EB42152C-293E-42F3-980F-43E680EE692F [Request] GET /episodes/ep1-type-safe-html-in-swift
2020-11-15T22:53:13.1183420Z 2020-11-15T22:53:12+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 EB42152C-293E-42F3-980F-43E680EE692F [Time] 40ms
2020-11-15T22:53:13.1185830Z 2020-11-15T22:53:12+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 A8BF3B24-AC92-444A-80EC-F216892E44D5 [Request] GET /episodes/ep1-type-safe-html-in-swift
2020-11-15T22:53:13.1188230Z 2020-11-15T22:53:12+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 A8BF3B24-AC92-444A-80EC-F216892E44D5 [Time] 43ms
2020-11-15T22:53:13.1190630Z 2020-11-15T22:53:12+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 35380F82-797F-45FF-9D9E-264EEC351330 [Request] GET /episodes/object-oriented-programming
2020-11-15T22:53:13.1192980Z 2020-11-15T22:53:12+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 35380F82-797F-45FF-9D9E-264EEC351330 [Time] 30ms
2020-11-15T22:53:13.1195450Z 2020-11-15T22:53:12+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 0A51D448-60E4-4AFC-8C01-35361DBD15C8 [Request] GET /episodes/ep1-proof-in-functions
2020-11-15T22:53:13.1197840Z 2020-11-15T22:53:12+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 0A51D448-60E4-4AFC-8C01-35361DBD15C8 [Time] 59ms
2020-11-15T22:53:13.1200200Z 2020-11-15T22:53:12+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 FF98BB66-9DED-4A15-B759-899E3431159A [Request] GET /episodes/ep2-proof-in-functions
2020-11-15T22:53:13.1202820Z 2020-11-15T22:53:12+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 FF98BB66-9DED-4A15-B759-899E3431159A [Time] 37ms
2020-11-15T22:53:13.1205430Z 2020-11-15T22:53:12+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 CEF37532-72C8-4290-9B5B-14456A7EB631 [Request] GET /collections/functions/functions-that-begin-with-a/ep2-proof-in-functions
2020-11-15T22:53:13.1208040Z 2020-11-15T22:53:12+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 CEF37532-72C8-4290-9B5B-14456A7EB631 [Time] 52ms
2020-11-15T22:53:13.1210680Z 2020-11-15T22:53:12+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 7F3D2118-3A1A-49CD-8DFC-434D6A7EC778 [Request] GET /collections/functions/functions-that-begin-with-a/ep1-type-safe-html-in-swift
2020-11-15T22:53:13.1213290Z 2020-11-15T22:53:12+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 7F3D2118-3A1A-49CD-8DFC-434D6A7EC778 [Time] 56ms
2020-11-15T22:53:13.1215620Z 2020-11-15T22:53:12+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 209C49D8-19D4-43C4-8EAC-50212D24238B [Request] GET /episodes/ep2-proof-in-functions
2020-11-15T22:53:13.1217890Z 2020-11-15T22:53:12+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 209C49D8-19D4-43C4-8EAC-50212D24238B [Time] 39ms
2020-11-15T22:53:13.1220280Z 2020-11-15T22:53:12+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift F1C44DAC-18FD-4074-BB60-8F9D64F969E3 [Request] GET /episodes/ep1-type-safe-html-in-swift
2020-11-15T22:53:13.1222750Z 2020-11-15T22:53:12+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift F1C44DAC-18FD-4074-BB60-8F9D64F969E3 [Time] 41ms
2020-11-15T22:53:13.1225120Z 2020-11-15T22:53:12+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 C07E4627-5B75-487D-B60C-BB6CD2DF5B6E [Request] GET /episodes/ep2-proof-in-functions
2020-11-15T22:53:13.1227550Z 2020-11-15T22:53:13+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift C07E4627-5B75-487D-B60C-BB6CD2DF5B6E [Time] 40ms
2020-11-15T22:53:13.1229880Z 2020-11-15T22:53:13+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 922B88BC-65E7-4449-9BC4-8C2C3A3D2B86 [Request] GET /episodes/ep2-proof-in-functions
2020-11-15T22:53:13.1232250Z 2020-11-15T22:53:13+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 922B88BC-65E7-4449-9BC4-8C2C3A3D2B86 [Time] 41ms
2020-11-15T22:53:13.1234790Z 2020-11-15T22:53:13+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift A1B6A9AC-138A-4BE1-BDDF-A94990307859 [Request] GET /episodes/ep2-proof-in-functions
2020-11-15T22:53:13.1237340Z 2020-11-15T22:53:13+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift A1B6A9AC-138A-4BE1-BDDF-A94990307859 [Time] 48ms
2020-11-15T22:53:13.1239710Z 2020-11-15T22:53:13+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 D3436801-0810-4B1F-A565-62D7A7CE329F [Request] GET /episodes/ep2-proof-in-functions
2020-11-15T22:53:13.1467170Z 2020-11-15T22:53:13+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 D3436801-0810-4B1F-A565-62D7A7CE329F [Time] 39ms
2020-11-15T22:53:13.1478960Z Test Case '-[PointFreeTests.EpisodePageTests testFreeEpisodePageSubscriber]' passed (0.043 seconds).
2020-11-15T22:53:13.1480970Z Test Case '-[PointFreeTests.EpisodePageTests testProgress_LoggedIn]' started.
2020-11-15T22:53:13.1516990Z 2020-11-15T22:53:13+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 8B9453C3-B845-4226-AD7A-728F185D2865 [Request] POST /episodes/ep2-proof-in-functions/progress
2020-11-15T22:53:13.1528460Z 2020-11-15T22:53:13+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 8B9453C3-B845-4226-AD7A-728F185D2865 [Time] 1ms
2020-11-15T22:53:13.1535450Z Test Case '-[PointFreeTests.EpisodePageTests testProgress_LoggedIn]' passed (0.006 seconds).
2020-11-15T22:53:13.1536980Z Test Case '-[PointFreeTests.EpisodePageTests testProgress_LoggedOut]' started.
2020-11-15T22:53:13.1571960Z 2020-11-15T22:53:13+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 6AC3F4DE-963E-4C2D-9689-0CD3F20BD2B0 [Request] POST /episodes/ep2-proof-in-functions/progress
2020-11-15T22:53:13.1580880Z 2020-11-15T22:53:13+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 6AC3F4DE-963E-4C2D-9689-0CD3F20BD2B0 [Time] 0ms
2020-11-15T22:53:13.1586440Z Test Case '-[PointFreeTests.EpisodePageTests testProgress_LoggedOut]' passed (0.005 seconds).
2020-11-15T22:53:13.1587750Z Test Suite 'EpisodePageTests' passed at 2020-11-15 22:53:13.158.
2020-11-15T22:53:13.1588330Z    Executed 18 tests, with 0 failures (0 unexpected) in 0.725 (0.726) seconds
2020-11-15T22:53:13.1589220Z Test Suite 'EpisodeTests' started at 2020-11-15 22:53:13.159
2020-11-15T22:53:13.1590240Z Test Case '-[ModelsTests.EpisodeTests testFreeSince]' started.
2020-11-15T22:53:13.1591420Z Test Case '-[ModelsTests.EpisodeTests testFreeSince]' passed (0.000 seconds).
2020-11-15T22:53:13.1592570Z Test Case '-[ModelsTests.EpisodeTests testIsSubscriberOnly]' started.
2020-11-15T22:53:13.1594330Z Test Case '-[ModelsTests.EpisodeTests testIsSubscriberOnly]' passed (0.000 seconds).
2020-11-15T22:53:13.1596080Z Test Case '-[ModelsTests.EpisodeTests testSlug]' started.
2020-11-15T22:53:13.1597480Z Test Case '-[ModelsTests.EpisodeTests testSlug]' passed (0.000 seconds).
2020-11-15T22:53:13.1598530Z Test Suite 'EpisodeTests' passed at 2020-11-15 22:53:13.159.
2020-11-15T22:53:13.1605290Z    Executed 3 tests, with 0 failures (0 unexpected) in 0.001 (0.001) seconds
2020-11-15T22:53:13.1606330Z Test Suite 'FreeEpisodeEmailTests' started at 2020-11-15 22:53:13.159
2020-11-15T22:53:13.1607560Z Test Case '-[PointFreeTests.FreeEpisodeEmailTests testFreeEpisodeEmail]' started.
2020-11-15T22:53:13.2326950Z Test Case '-[PointFreeTests.FreeEpisodeEmailTests testFreeEpisodeEmail]' passed (0.073 seconds).
2020-11-15T22:53:13.2328720Z Test Suite 'FreeEpisodeEmailTests' passed at 2020-11-15 22:53:13.232.
2020-11-15T22:53:13.2329330Z    Executed 1 test, with 0 failures (0 unexpected) in 0.073 (0.073) seconds
2020-11-15T22:53:13.2331040Z Test Suite 'FunctionalCssTests' started at 2020-11-15 22:53:13.233
2020-11-15T22:53:13.2333360Z Test Case '-[FunctionalCssTests.FunctionalCssTests testFunctionalCss]' started.
2020-11-15T22:53:13.2632400Z Test Case '-[FunctionalCssTests.FunctionalCssTests testFunctionalCss]' passed (0.030 seconds).
2020-11-15T22:53:13.2633840Z Test Suite 'FunctionalCssTests' passed at 2020-11-15 22:53:13.263.
2020-11-15T22:53:13.2634350Z    Executed 1 test, with 0 failures (0 unexpected) in 0.030 (0.030) seconds
2020-11-15T22:53:13.2635590Z Test Suite 'GhostTests' started at 2020-11-15 22:53:13.263
2020-11-15T22:53:13.2636550Z Test Case '-[PointFreeTests.GhostTests testEndGhosting_HappyPath]' started.
2020-11-15T22:53:13.2657060Z 2020-11-15T22:53:13+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 90BC0E5E-8D13-4E72-BB4A-016806B15531 [Request] POST /ghosting/end
2020-11-15T22:53:13.2728470Z Test Case '-[PointFreeTests.GhostTests testEndGhosting_HappyPath]' passed (0.005 seconds).
2020-11-15T22:53:13.2732840Z 2020-11-15T22:53:13+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 90BC0E5E-8D13-4E72-BB4A-016806B15531 [Time] 1ms
2020-11-15T22:53:13.2739620Z Test Case '-[PointFreeTests.GhostTests testStartGhosting_HappyPath]' started.
2020-11-15T22:53:13.2742510Z Test Case '-[PointFreeTests.GhostTests testStartGhosting_HappyPath]' passed (0.006 seconds).
2020-11-15T22:53:13.2744360Z Test Case '-[PointFreeTests.GhostTests testStartGhosting_InvalidGhostee]' started.
2020-11-15T22:53:13.2746880Z 2020-11-15T22:53:13+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 458D97EE-E4AC-43B6-B3D0-4B28CF8BFDD6 [Request] POST /admin/ghost/start
2020-11-15T22:53:13.2749760Z 2020-11-15T22:53:13+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 458D97EE-E4AC-43B6-B3D0-4B28CF8BFDD6 [Time] 2ms
2020-11-15T22:53:13.2793410Z 2020-11-15T22:53:13+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 51FDC2C5-7FAF-4BDA-B379-A115CAC3907E [Request] POST /admin/ghost/start
2020-11-15T22:53:13.2810820Z 2020-11-15T22:53:13+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 51FDC2C5-7FAF-4BDA-B379-A115CAC3907E [Time] 2ms
2020-11-15T22:53:13.2935000Z Test Case '-[PointFreeTests.GhostTests testStartGhosting_InvalidGhostee]' passed (0.008 seconds).
2020-11-15T22:53:13.2937090Z 2020-11-15T22:53:13+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 66C94529-62A5-4BA7-B3F2-C13AA3F07C3D [Request] POST /admin/ghost/start
2020-11-15T22:53:13.2940030Z Test Case '-[PointFreeTests.GhostTests testStartGhosting_NonAdmin]' started.
2020-11-15T22:53:13.2941820Z Test Case '-[PointFreeTests.GhostTests testStartGhosting_NonAdmin]' passed (0.004 seconds).
2020-11-15T22:53:13.2943330Z Test Suite 'GhostTests' passed at 2020-11-15 22:53:13.286.
2020-11-15T22:53:13.2944230Z    Executed 4 tests, with 0 failures (0 unexpected) in 0.022 (0.023) seconds
2020-11-15T22:53:13.2945470Z Test Suite 'GitHubTests' started at 2020-11-15 22:53:13.286
2020-11-15T22:53:13.2946860Z Test Case '-[GitHubTests.GitHubTests testRequests]' started.
2020-11-15T22:53:13.2948490Z Test Case '-[GitHubTests.GitHubTests testRequests]' passed (0.002 seconds).
2020-11-15T22:53:13.2949890Z Test Suite 'GitHubTests' passed at 2020-11-15 22:53:13.288.
2020-11-15T22:53:13.2951140Z    Executed 1 test, with 0 failures (0 unexpected) in 0.002 (0.003) seconds
2020-11-15T22:53:13.2952450Z Test Suite 'HomeTests' started at 2020-11-15 22:53:13.288
2020-11-15T22:53:13.2954010Z Test Case '-[PointFreeTests.HomeTests testEpisodesIndex]' started.
2020-11-15T22:53:13.2955710Z 2020-11-15T22:53:13+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 66C94529-62A5-4BA7-B3F2-C13AA3F07C3D [Time] 1ms
2020-11-15T22:53:13.2958010Z Test Case '-[PointFreeTests.HomeTests testEpisodesIndex]' passed (0.004 seconds).
2020-11-15T22:53:13.2959820Z 2020-11-15T22:53:13+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 1BEC3F59-1D65-4C7C-A609-D583E98C44CB [Request] GET /episodes
2020-11-15T22:53:13.2962340Z Test Case '-[PointFreeTests.HomeTests testHomepage_LoggedOut]' started.
2020-11-15T22:53:13.2964080Z 2020-11-15T22:53:13+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 1BEC3F59-1D65-4C7C-A609-D583E98C44CB [Time] 0ms
2020-11-15T22:53:13.3042450Z 2020-11-15T22:53:13+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 A92418EE-B547-4860-A8FC-EE8BB81A460C [Request] GET
2020-11-15T22:53:13.3438800Z 2020-11-15T22:53:13+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift A92418EE-B547-4860-A8FC-EE8BB81A460C [Time] 46ms
2020-11-15T22:53:13.3448370Z Test Case '-[PointFreeTests.HomeTests testHomepage_LoggedOut]' passed (0.053 seconds).
2020-11-15T22:53:13.3449550Z Test Case '-[PointFreeTests.HomeTests testHomepage_Subscriber]' started.
2020-11-15T22:53:13.3468490Z 2020-11-15T22:53:13+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 B1013BF7-3918-4C54-98E3-61C5AE931532 [Request] GET
2020-11-15T22:53:13.3901780Z 2020-11-15T22:53:13+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 B1013BF7-3918-4C54-98E3-61C5AE931532 [Time] 43ms
2020-11-15T22:53:13.3912220Z Test Case '-[PointFreeTests.HomeTests testHomepage_Subscriber]' passed (0.046 seconds).
2020-11-15T22:53:13.3913240Z Test Suite 'HomeTests' passed at 2020-11-15 22:53:13.391.
2020-11-15T22:53:13.3913680Z    Executed 3 tests, with 0 failures (0 unexpected) in 0.103 (0.103) seconds
2020-11-15T22:53:13.3914550Z Test Suite 'HtmlCssInlinerTests' started at 2020-11-15 22:53:13.391
2020-11-15T22:53:13.3915750Z Test Case '-[PointFreeTests.HtmlCssInlinerTests testHtmlCssInliner]' started.
2020-11-15T22:53:13.3955090Z Test Case '-[PointFreeTests.HtmlCssInlinerTests testHtmlCssInliner]' passed (0.004 seconds).
2020-11-15T22:53:13.3956380Z Test Suite 'HtmlCssInlinerTests' passed at 2020-11-15 22:53:13.395.
2020-11-15T22:53:13.3956920Z    Executed 1 test, with 0 failures (0 unexpected) in 0.004 (0.004) seconds
2020-11-15T22:53:13.3957830Z Test Suite 'InviteIntegrationTests' started at 2020-11-15 22:53:13.395
2020-11-15T22:53:13.3959110Z Test Case '-[PointFreeTests.InviteIntegrationTests testAcceptInvitation_HappyPath]' started.
2020-11-15T22:53:13.4222460Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:13.4269120Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:13.4270720Z drop cascades to extension uuid-ossp
2020-11-15T22:53:13.4271470Z drop cascades to extension citext
2020-11-15T22:53:13.4299870Z drop cascades to table users
2020-11-15T22:53:13.4307160Z drop cascades to table subscriptions
2020-11-15T22:53:13.4307880Z drop cascades to table team_invites
2020-11-15T22:53:13.4308530Z drop cascades to table email_settings
2020-11-15T22:53:13.4309180Z drop cascades to table episode_credits
2020-11-15T22:53:13.4309840Z drop cascades to table feed_request_events
2020-11-15T22:53:13.4310950Z drop cascades to function update_updated_at()
2020-11-15T22:53:13.4311740Z drop cascades to table enterprise_accounts
2020-11-15T22:53:13.4312420Z drop cascades to table enterprise_emails
2020-11-15T22:53:13.4313080Z drop cascades to table episode_progresses
2020-11-15T22:53:13.4313780Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:13.4314460Z drop cascades to sequence test_uuids
2020-11-15T22:53:13.4315100Z drop cascades to sequence test_shortids
2020-11-15T22:53:14.5605470Z 2020-11-15T22:53:14+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 7E7DF052-EB64-4158-8097-11E8AD4A60C9 [Request] POST /invites/00000000-0000-0000-0000-000000000014/accept
2020-11-15T22:53:14.6060010Z 2020-11-15T22:53:14+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 7E7DF052-EB64-4158-8097-11E8AD4A60C9 [Time] 45ms
2020-11-15T22:53:14.6140620Z Test Case '-[PointFreeTests.InviteIntegrationTests testAcceptInvitation_HappyPath]' passed (1.218 seconds).
2020-11-15T22:53:14.6145400Z Test Case '-[PointFreeTests.InviteIntegrationTests testAcceptInvitation_InviterHasCancelingStripeSubscription]' started.
2020-11-15T22:53:14.6278570Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:14.6279140Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:14.6280300Z drop cascades to extension uuid-ossp
2020-11-15T22:53:14.6280690Z drop cascades to extension citext
2020-11-15T22:53:14.6281030Z drop cascades to table users
2020-11-15T22:53:14.6281390Z drop cascades to table subscriptions
2020-11-15T22:53:14.6281780Z drop cascades to table team_invites
2020-11-15T22:53:14.6282130Z drop cascades to table email_settings
2020-11-15T22:53:14.6282500Z drop cascades to table episode_credits
2020-11-15T22:53:14.6282880Z drop cascades to table feed_request_events
2020-11-15T22:53:14.6283280Z drop cascades to function update_updated_at()
2020-11-15T22:53:14.6283690Z drop cascades to table enterprise_accounts
2020-11-15T22:53:14.6284090Z drop cascades to table enterprise_emails
2020-11-15T22:53:14.6284480Z drop cascades to table episode_progresses
2020-11-15T22:53:14.6284900Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:14.6285290Z drop cascades to sequence test_uuids
2020-11-15T22:53:14.6285650Z drop cascades to sequence test_shortids
2020-11-15T22:53:15.7981820Z 2020-11-15T22:53:15+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 18409D8F-F0FF-4048-A4D0-4523E734CEC5 [Request] POST /invites/00000000-0000-0000-0000-000000000014/accept
2020-11-15T22:53:15.8321860Z 2020-11-15T22:53:15+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 18409D8F-F0FF-4048-A4D0-4523E734CEC5 [Time] 33ms
2020-11-15T22:53:15.8388780Z Test Case '-[PointFreeTests.InviteIntegrationTests testAcceptInvitation_InviterHasCancelingStripeSubscription]' passed (1.225 seconds).
2020-11-15T22:53:15.8391600Z Test Case '-[PointFreeTests.InviteIntegrationTests testAcceptInvitation_InviterHasInactiveStripeSubscription]' started.
2020-11-15T22:53:15.8542830Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:15.8543380Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:15.8544450Z drop cascades to extension uuid-ossp
2020-11-15T22:53:15.8544840Z drop cascades to extension citext
2020-11-15T22:53:15.8545170Z drop cascades to table users
2020-11-15T22:53:15.8545530Z drop cascades to table subscriptions
2020-11-15T22:53:15.8545950Z drop cascades to table team_invites
2020-11-15T22:53:15.8546310Z drop cascades to table email_settings
2020-11-15T22:53:15.8546660Z drop cascades to table episode_credits
2020-11-15T22:53:15.8547130Z drop cascades to table feed_request_events
2020-11-15T22:53:15.8547540Z drop cascades to function update_updated_at()
2020-11-15T22:53:15.8548270Z drop cascades to table enterprise_accounts
2020-11-15T22:53:15.8548720Z drop cascades to table enterprise_emails
2020-11-15T22:53:15.8549110Z drop cascades to table episode_progresses
2020-11-15T22:53:15.8549520Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:15.8549920Z drop cascades to sequence test_uuids
2020-11-15T22:53:15.8550280Z drop cascades to sequence test_shortids
2020-11-15T22:53:17.0179170Z 2020-11-15T22:53:17+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 96CDA505-FB6F-4064-90A8-9DA099E54C02 [Request] POST /invites/00000000-0000-0000-0000-000000000014/accept
2020-11-15T22:53:17.0561070Z 2020-11-15T22:53:17+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 96CDA505-FB6F-4064-90A8-9DA099E54C02 [Time] 37ms
2020-11-15T22:53:17.0644140Z Test Case '-[PointFreeTests.InviteIntegrationTests testAcceptInvitation_InviterHasInactiveStripeSubscription]' passed (1.225 seconds).
2020-11-15T22:53:17.0646360Z Test Case '-[PointFreeTests.InviteIntegrationTests testAcceptInvitation_InviterIsNotSubscriber]' started.
2020-11-15T22:53:17.0773150Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:17.0774190Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:17.0775350Z drop cascades to extension uuid-ossp
2020-11-15T22:53:17.0775730Z drop cascades to extension citext
2020-11-15T22:53:17.0776070Z drop cascades to table users
2020-11-15T22:53:17.0776420Z drop cascades to table subscriptions
2020-11-15T22:53:17.0776770Z drop cascades to table team_invites
2020-11-15T22:53:17.0777150Z drop cascades to table email_settings
2020-11-15T22:53:17.0777520Z drop cascades to table episode_credits
2020-11-15T22:53:17.0777890Z drop cascades to table feed_request_events
2020-11-15T22:53:17.0778290Z drop cascades to function update_updated_at()
2020-11-15T22:53:17.0778690Z drop cascades to table enterprise_accounts
2020-11-15T22:53:17.0779090Z drop cascades to table enterprise_emails
2020-11-15T22:53:17.0779490Z drop cascades to table episode_progresses
2020-11-15T22:53:17.0779890Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:17.0780280Z drop cascades to sequence test_uuids
2020-11-15T22:53:17.0780650Z drop cascades to sequence test_shortids
2020-11-15T22:53:18.2742610Z 2020-11-15T22:53:18+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift BCC3E3D3-2C96-4840-A75F-78901A0729FD [Request] POST /invites/00000000-0000-0000-0000-000000000013/accept
2020-11-15T22:53:18.3108950Z 2020-11-15T22:53:18+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 BCC3E3D3-2C96-4840-A75F-78901A0729FD [Time] 36ms
2020-11-15T22:53:18.3181820Z Test Case '-[PointFreeTests.InviteIntegrationTests testAcceptInvitation_InviterIsNotSubscriber]' passed (1.254 seconds).
2020-11-15T22:53:18.3184050Z Test Case '-[PointFreeTests.InviteIntegrationTests testAddTeammate]' started.
2020-11-15T22:53:18.3315720Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:18.3316310Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:18.3317480Z drop cascades to extension uuid-ossp
2020-11-15T22:53:18.3317870Z drop cascades to extension citext
2020-11-15T22:53:18.3318190Z drop cascades to table users
2020-11-15T22:53:18.3318540Z drop cascades to table subscriptions
2020-11-15T22:53:18.3318910Z drop cascades to table team_invites
2020-11-15T22:53:18.3319260Z drop cascades to table email_settings
2020-11-15T22:53:18.3319650Z drop cascades to table episode_credits
2020-11-15T22:53:18.3320020Z drop cascades to table feed_request_events
2020-11-15T22:53:18.3320420Z drop cascades to function update_updated_at()
2020-11-15T22:53:18.3320820Z drop cascades to table enterprise_accounts
2020-11-15T22:53:18.3321220Z drop cascades to table enterprise_emails
2020-11-15T22:53:18.3322240Z drop cascades to table episode_progresses
2020-11-15T22:53:18.3322720Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:18.3323120Z drop cascades to sequence test_uuids
2020-11-15T22:53:18.3323480Z drop cascades to sequence test_shortids
2020-11-15T22:53:19.4918990Z 2020-11-15T22:53:19+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 4159A07F-3F68-4607-A52E-35884B8BB562 [Request] POST /invites/add
2020-11-15T22:53:19.5877620Z 2020-11-15T22:53:19+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 4159A07F-3F68-4607-A52E-35884B8BB562 [Time] 95ms
2020-11-15T22:53:19.5946000Z Test Case '-[PointFreeTests.InviteIntegrationTests testAddTeammate]' passed (1.276 seconds).
2020-11-15T22:53:19.5948540Z Test Case '-[PointFreeTests.InviteIntegrationTests testResendInvite_CurrentUserIsNotInviter]' started.
2020-11-15T22:53:19.6080400Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:19.6080910Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:19.6082090Z drop cascades to extension uuid-ossp
2020-11-15T22:53:19.6082480Z drop cascades to extension citext
2020-11-15T22:53:19.6082810Z drop cascades to table users
2020-11-15T22:53:19.6083160Z drop cascades to table subscriptions
2020-11-15T22:53:19.6083530Z drop cascades to table team_invites
2020-11-15T22:53:19.6083880Z drop cascades to table email_settings
2020-11-15T22:53:19.6084250Z drop cascades to table episode_credits
2020-11-15T22:53:19.6084620Z drop cascades to table feed_request_events
2020-11-15T22:53:19.6085030Z drop cascades to function update_updated_at()
2020-11-15T22:53:19.6085430Z drop cascades to table enterprise_accounts
2020-11-15T22:53:19.6085840Z drop cascades to table enterprise_emails
2020-11-15T22:53:19.6086230Z drop cascades to table episode_progresses
2020-11-15T22:53:19.6086650Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:19.6087040Z drop cascades to sequence test_uuids
2020-11-15T22:53:19.6087400Z drop cascades to sequence test_shortids
2020-11-15T22:53:20.8043580Z 2020-11-15T22:53:20+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 4E0B0FC3-FE65-4A71-B57A-B173A2BDB930 [Request] POST /invites/00000000-0000-0000-0000-000000000013/resend
2020-11-15T22:53:20.8272730Z 2020-11-15T22:53:20+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 4E0B0FC3-FE65-4A71-B57A-B173A2BDB930 [Time] 22ms
2020-11-15T22:53:20.8276790Z Test Case '-[PointFreeTests.InviteIntegrationTests testResendInvite_CurrentUserIsNotInviter]' passed (1.233 seconds).
2020-11-15T22:53:20.8278610Z Test Case '-[PointFreeTests.InviteIntegrationTests testResendInvite_HappyPath]' started.
2020-11-15T22:53:20.8615510Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:20.8616090Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:20.8617300Z drop cascades to extension uuid-ossp
2020-11-15T22:53:20.8617680Z drop cascades to extension citext
2020-11-15T22:53:20.8618020Z drop cascades to table users
2020-11-15T22:53:20.8618360Z drop cascades to table subscriptions
2020-11-15T22:53:20.8618730Z drop cascades to table team_invites
2020-11-15T22:53:20.8619080Z drop cascades to table email_settings
2020-11-15T22:53:20.8619450Z drop cascades to table episode_credits
2020-11-15T22:53:20.8619820Z drop cascades to table feed_request_events
2020-11-15T22:53:20.8620220Z drop cascades to function update_updated_at()
2020-11-15T22:53:20.8620630Z drop cascades to table enterprise_accounts
2020-11-15T22:53:20.8621030Z drop cascades to table enterprise_emails
2020-11-15T22:53:20.8621420Z drop cascades to table episode_progresses
2020-11-15T22:53:20.8621840Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:20.8622240Z drop cascades to sequence test_uuids
2020-11-15T22:53:20.8623110Z drop cascades to sequence test_shortids
2020-11-15T22:53:21.8396570Z 2020-11-15T22:53:21+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 8DFCF5F9-B7AA-45C0-A872-A3BE59437140 [Request] POST /invites/00000000-0000-0000-0000-000000000007/resend
2020-11-15T22:53:21.9045850Z 2020-11-15T22:53:21+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 8DFCF5F9-B7AA-45C0-A872-A3BE59437140 [Time] 64ms
2020-11-15T22:53:21.9054160Z Test Case '-[PointFreeTests.InviteIntegrationTests testResendInvite_HappyPath]' passed (1.078 seconds).
2020-11-15T22:53:21.9056330Z Test Case '-[PointFreeTests.InviteIntegrationTests testRevokeInvite_CurrentUserIsNotInviter]' started.
2020-11-15T22:53:21.9189050Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:21.9189650Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:21.9190780Z drop cascades to extension uuid-ossp
2020-11-15T22:53:21.9191170Z drop cascades to extension citext
2020-11-15T22:53:21.9191500Z drop cascades to table users
2020-11-15T22:53:21.9191850Z drop cascades to table subscriptions
2020-11-15T22:53:21.9192220Z drop cascades to table team_invites
2020-11-15T22:53:21.9192570Z drop cascades to table email_settings
2020-11-15T22:53:21.9192940Z drop cascades to table episode_credits
2020-11-15T22:53:21.9193310Z drop cascades to table feed_request_events
2020-11-15T22:53:21.9193700Z drop cascades to function update_updated_at()
2020-11-15T22:53:21.9194110Z drop cascades to table enterprise_accounts
2020-11-15T22:53:21.9194520Z drop cascades to table enterprise_emails
2020-11-15T22:53:21.9194920Z drop cascades to table episode_progresses
2020-11-15T22:53:21.9195330Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:21.9195730Z drop cascades to sequence test_uuids
2020-11-15T22:53:21.9196080Z drop cascades to sequence test_shortids
2020-11-15T22:53:23.0285030Z 2020-11-15T22:53:23+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift F4D5FFB6-5C0A-4DBD-9845-7BB3795E22B1 [Request] POST /invites/00000000-0000-0000-0000-000000000013/revoke
2020-11-15T22:53:23.0529660Z 2020-11-15T22:53:23+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift F4D5FFB6-5C0A-4DBD-9845-7BB3795E22B1 [Time] 24ms
2020-11-15T22:53:23.0606840Z Test Case '-[PointFreeTests.InviteIntegrationTests testRevokeInvite_CurrentUserIsNotInviter]' passed (1.155 seconds).
2020-11-15T22:53:23.0609270Z Test Case '-[PointFreeTests.InviteIntegrationTests testRevokeInvite_HappyPath]' started.
2020-11-15T22:53:23.0745420Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:23.0745970Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:23.0747280Z drop cascades to extension uuid-ossp
2020-11-15T22:53:23.0747700Z drop cascades to extension citext
2020-11-15T22:53:23.0748030Z drop cascades to table users
2020-11-15T22:53:23.0748390Z drop cascades to table subscriptions
2020-11-15T22:53:23.0748750Z drop cascades to table team_invites
2020-11-15T22:53:23.0749100Z drop cascades to table email_settings
2020-11-15T22:53:23.0749470Z drop cascades to table episode_credits
2020-11-15T22:53:23.0749840Z drop cascades to table feed_request_events
2020-11-15T22:53:23.0750240Z drop cascades to function update_updated_at()
2020-11-15T22:53:23.0750650Z drop cascades to table enterprise_accounts
2020-11-15T22:53:23.0751050Z drop cascades to table enterprise_emails
2020-11-15T22:53:23.0751450Z drop cascades to table episode_progresses
2020-11-15T22:53:23.0751860Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:23.0752260Z drop cascades to sequence test_uuids
2020-11-15T22:53:23.0752620Z drop cascades to sequence test_shortids
2020-11-15T22:53:24.1741970Z 2020-11-15T22:53:24+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 CA1756AB-A32F-4FF7-B6DC-D34383D1EAE7 [Request] POST /invites/00000000-0000-0000-0000-000000000007/revoke
2020-11-15T22:53:24.2668030Z 2020-11-15T22:53:24+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift CA1756AB-A32F-4FF7-B6DC-D34383D1EAE7 [Time] 92ms
2020-11-15T22:53:24.2736320Z Test Case '-[PointFreeTests.InviteIntegrationTests testRevokeInvite_HappyPath]' passed (1.213 seconds).
2020-11-15T22:53:24.2737730Z Test Suite 'InviteIntegrationTests' passed at 2020-11-15 22:53:24.273.
2020-11-15T22:53:24.2738800Z    Executed 9 tests, with 0 failures (0 unexpected) in 10.877 (10.878) seconds
2020-11-15T22:53:24.2739650Z Test Suite 'InviteTests' started at 2020-11-15 22:53:24.273
2020-11-15T22:53:24.2740690Z Test Case '-[PointFreeTests.InviteTests testShowInvite_LoggedIn_NonSubscriber]' started.
2020-11-15T22:53:24.2773280Z 2020-11-15T22:53:24+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 45595FC5-DD39-4FEB-90EE-8D9899DBCB44 [Request] GET /invites/DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF
2020-11-15T22:53:24.3071060Z 2020-11-15T22:53:24+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 45595FC5-DD39-4FEB-90EE-8D9899DBCB44 [Time] 29ms
2020-11-15T22:53:24.3080710Z Test Case '-[PointFreeTests.InviteTests testShowInvite_LoggedIn_NonSubscriber]' passed (0.034 seconds).
2020-11-15T22:53:24.3082250Z Test Case '-[PointFreeTests.InviteTests testShowInvite_LoggedIn_Subscriber]' started.
2020-11-15T22:53:24.3114700Z 2020-11-15T22:53:24+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 89C3EA7B-DF74-48F0-8AB1-B75CBF13DBA0 [Request] GET /invites/DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF
2020-11-15T22:53:24.3128070Z 2020-11-15T22:53:24+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 89C3EA7B-DF74-48F0-8AB1-B75CBF13DBA0 [Time] 1ms
2020-11-15T22:53:24.3133220Z Test Case '-[PointFreeTests.InviteTests testShowInvite_LoggedIn_Subscriber]' passed (0.005 seconds).
2020-11-15T22:53:24.3134510Z Test Case '-[PointFreeTests.InviteTests testShowInvite_LoggedOut]' started.
2020-11-15T22:53:24.3165520Z 2020-11-15T22:53:24+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 C640508A-E551-4131-9067-E50ABFC0C225 [Request] GET /invites/DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF
2020-11-15T22:53:24.3493970Z 2020-11-15T22:53:24+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 C640508A-E551-4131-9067-E50ABFC0C225 [Time] 32ms
2020-11-15T22:53:24.3503720Z Test Case '-[PointFreeTests.InviteTests testShowInvite_LoggedOut]' passed (0.037 seconds).
2020-11-15T22:53:24.3505010Z Test Suite 'InviteTests' passed at 2020-11-15 22:53:24.350.
2020-11-15T22:53:24.3505460Z    Executed 3 tests, with 0 failures (0 unexpected) in 0.077 (0.077) seconds
2020-11-15T22:53:24.3506280Z Test Suite 'InvoicesTests' started at 2020-11-15 22:53:24.350
2020-11-15T22:53:24.3507240Z Test Case '-[PointFreeTests.InvoicesTests testInvoice]' started.
2020-11-15T22:53:24.3587790Z 2020-11-15T22:53:24+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 8A6EA3F9-FE8C-49C4-AB2E-FC7D884B10D1 [Request] GET /account/invoices/in_test
2020-11-15T22:53:24.3876510Z Test Case '-[PointFreeTests.InvoicesTests testInvoice]' passed (0.037 seconds).
2020-11-15T22:53:24.3878780Z 2020-11-15T22:53:24+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 8A6EA3F9-FE8C-49C4-AB2E-FC7D884B10D1 [Time] 32ms
2020-11-15T22:53:24.3982360Z Test Case '-[PointFreeTests.InvoicesTests testInvoice_InvoiceBilling]' started.
2020-11-15T22:53:24.3984360Z 2020-11-15T22:53:24+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 802B8B92-0775-40E5-A85D-7FBCE136C14E [Request] GET /account/invoices/in_test
2020-11-15T22:53:24.4208360Z Test Case '-[PointFreeTests.InvoicesTests testInvoice_InvoiceBilling]' passed (0.034 seconds).
2020-11-15T22:53:24.4210320Z 2020-11-15T22:53:24+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 802B8B92-0775-40E5-A85D-7FBCE136C14E [Time] 28ms
2020-11-15T22:53:24.4323900Z Test Case '-[PointFreeTests.InvoicesTests testInvoices]' started.
2020-11-15T22:53:24.4325940Z 2020-11-15T22:53:24+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 1C01F549-38F9-4F8F-9CDF-3ADBD7CF6453 [Request] GET /account/invoices
2020-11-15T22:53:24.4589010Z 2020-11-15T22:53:24+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 1C01F549-38F9-4F8F-9CDF-3ADBD7CF6453 [Time] 32ms
2020-11-15T22:53:24.4608940Z Test Case '-[PointFreeTests.InvoicesTests testInvoices]' passed (0.038 seconds).
2020-11-15T22:53:24.4628240Z Test Case '-[PointFreeTests.InvoicesTests testInvoiceWithDiscount]' started.
2020-11-15T22:53:24.4630560Z 2020-11-15T22:53:24+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 B941583D-4216-45CF-BBAF-E018F4315923 [Request] GET /account/invoices/in_test
2020-11-15T22:53:24.4911130Z Test Case '-[PointFreeTests.InvoicesTests testInvoiceWithDiscount]' passed (0.032 seconds).
2020-11-15T22:53:24.4913180Z 2020-11-15T22:53:24+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 B941583D-4216-45CF-BBAF-E018F4315923 [Time] 28ms
2020-11-15T22:53:24.4946780Z Test Suite 'InvoicesTests' passed at 2020-11-15 22:53:24.491.
2020-11-15T22:53:24.4954920Z    Executed 4 tests, with 0 failures (0 unexpected) in 0.140 (0.140) seconds
2020-11-15T22:53:24.4956930Z Test Suite 'MetaLayoutTests' started at 2020-11-15 22:53:24.491
2020-11-15T22:53:24.4959560Z Test Case '-[PointFreeTests.MetaLayoutTests testMetaTagsWithStyleTag]' started.
2020-11-15T22:53:24.4961610Z Test Case '-[PointFreeTests.MetaLayoutTests testMetaTagsWithStyleTag]' passed (0.002 seconds).
2020-11-15T22:53:24.4964890Z Test Suite 'MetaLayoutTests' passed at 2020-11-15 22:53:24.493.
2020-11-15T22:53:24.4965760Z    Executed 1 test, with 0 failures (0 unexpected) in 0.002 (0.003) seconds
2020-11-15T22:53:24.4966750Z Test Suite 'MinimalNavViewTests' started at 2020-11-15 22:53:24.493
2020-11-15T22:53:24.4968320Z Test Case '-[PointFreeTests.MinimalNavViewTests testNav_Html]' started.
2020-11-15T22:53:24.6778950Z Test Case '-[PointFreeTests.MinimalNavViewTests testNav_Html]' passed (0.184 seconds).
2020-11-15T22:53:24.6780900Z Test Case '-[PointFreeTests.MinimalNavViewTests testNav_Screenshots]' started.
2020-11-15T22:53:24.8452040Z Test Case '-[PointFreeTests.MinimalNavViewTests testNav_Screenshots]' passed (0.167 seconds).
2020-11-15T22:53:24.8454160Z Test Suite 'MinimalNavViewTests' passed at 2020-11-15 22:53:24.845.
2020-11-15T22:53:24.8454690Z    Executed 2 tests, with 0 failures (0 unexpected) in 0.351 (0.352) seconds
2020-11-15T22:53:24.8455600Z Test Suite 'NewBlogPostEmailTests' started at 2020-11-15 22:53:24.845
2020-11-15T22:53:24.8457000Z Test Case '-[PointFreeTests.NewBlogPostEmailTests testNewBlogPostEmail_Announcements_NonSubscriber]' started.
2020-11-15T22:53:24.9107380Z Test Case '-[PointFreeTests.NewBlogPostEmailTests testNewBlogPostEmail_Announcements_NonSubscriber]' passed (0.065 seconds).
2020-11-15T22:53:24.9109740Z Test Case '-[PointFreeTests.NewBlogPostEmailTests testNewBlogPostEmail_Announcements_Subscriber]' started.
2020-11-15T22:53:24.9759370Z Test Case '-[PointFreeTests.NewBlogPostEmailTests testNewBlogPostEmail_Announcements_Subscriber]' passed (0.065 seconds).
2020-11-15T22:53:24.9763110Z Test Case '-[PointFreeTests.NewBlogPostEmailTests testNewBlogPostEmail_NoAnnouncements_NonSubscriber]' started.
2020-11-15T22:53:25.0382440Z Test Case '-[PointFreeTests.NewBlogPostEmailTests testNewBlogPostEmail_NoAnnouncements_NonSubscriber]' passed (0.063 seconds).
2020-11-15T22:53:25.0385380Z Test Case '-[PointFreeTests.NewBlogPostEmailTests testNewBlogPostEmail_NoAnnouncements_Subscriber]' started.
2020-11-15T22:53:25.0968500Z Test Case '-[PointFreeTests.NewBlogPostEmailTests testNewBlogPostEmail_NoAnnouncements_Subscriber]' passed (0.059 seconds).
2020-11-15T22:53:25.0970340Z Test Case '-[PointFreeTests.NewBlogPostEmailTests testNewBlogPostEmail_NoCoverImage]' started.
2020-11-15T22:53:25.1520690Z Test Case '-[PointFreeTests.NewBlogPostEmailTests testNewBlogPostEmail_NoCoverImage]' passed (0.055 seconds).
2020-11-15T22:53:25.1522440Z Test Case '-[PointFreeTests.NewBlogPostEmailTests testNewBlogPostRoute]' started.
2020-11-15T22:53:25.1554700Z Test Case '-[PointFreeTests.NewBlogPostEmailTests testNewBlogPostRoute]' passed (0.003 seconds).
2020-11-15T22:53:25.1555990Z Test Suite 'NewBlogPostEmailTests' passed at 2020-11-15 22:53:25.155.
2020-11-15T22:53:25.1556530Z    Executed 6 tests, with 0 failures (0 unexpected) in 0.310 (0.310) seconds
2020-11-15T22:53:25.1557380Z Test Suite 'NewEpisodeEmailTests' started at 2020-11-15 22:53:25.155
2020-11-15T22:53:25.1558700Z Test Case '-[PointFreeTests.NewEpisodeEmailTests testNewEpisodeEmail_Announcement_NonSubscriber]' started.
2020-11-15T22:53:25.2334530Z Test Case '-[PointFreeTests.NewEpisodeEmailTests testNewEpisodeEmail_Announcement_NonSubscriber]' passed (0.077 seconds).
2020-11-15T22:53:25.2336830Z Test Case '-[PointFreeTests.NewEpisodeEmailTests testNewEpisodeEmail_Announcement_Subscriber]' started.
2020-11-15T22:53:25.2975510Z Test Case '-[PointFreeTests.NewEpisodeEmailTests testNewEpisodeEmail_Announcement_Subscriber]' passed (0.065 seconds).
2020-11-15T22:53:25.2977390Z Test Case '-[PointFreeTests.NewEpisodeEmailTests testNewEpisodeEmail_FreeEpisode_NonSubscriber]' started.
2020-11-15T22:53:25.3602200Z Test Case '-[PointFreeTests.NewEpisodeEmailTests testNewEpisodeEmail_FreeEpisode_NonSubscriber]' passed (0.063 seconds).
2020-11-15T22:53:25.3604010Z Test Case '-[PointFreeTests.NewEpisodeEmailTests testNewEpisodeEmail_Subscriber]' started.
2020-11-15T22:53:25.4199140Z Test Case '-[PointFreeTests.NewEpisodeEmailTests testNewEpisodeEmail_Subscriber]' passed (0.060 seconds).
2020-11-15T22:53:25.4200830Z Test Suite 'NewEpisodeEmailTests' passed at 2020-11-15 22:53:25.420.
2020-11-15T22:53:25.4207110Z    Executed 4 tests, with 0 failures (0 unexpected) in 0.264 (0.264) seconds
2020-11-15T22:53:25.4208320Z Test Suite 'NewslettersIntegrationTests' started at 2020-11-15 22:53:25.420
2020-11-15T22:53:25.4209780Z Test Case '-[PointFreeTests.NewslettersIntegrationTests testExpressUnsubscribe]' started.
2020-11-15T22:53:25.4359910Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:25.4362620Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:25.4364070Z drop cascades to extension uuid-ossp
2020-11-15T22:53:25.4370100Z drop cascades to extension citext
2020-11-15T22:53:25.4370500Z drop cascades to table users
2020-11-15T22:53:25.4370900Z drop cascades to table subscriptions
2020-11-15T22:53:25.4371270Z drop cascades to table team_invites
2020-11-15T22:53:25.4371630Z drop cascades to table email_settings
2020-11-15T22:53:25.4372020Z drop cascades to table episode_credits
2020-11-15T22:53:25.4372400Z drop cascades to table feed_request_events
2020-11-15T22:53:25.4372800Z drop cascades to function update_updated_at()
2020-11-15T22:53:25.4373210Z drop cascades to table enterprise_accounts
2020-11-15T22:53:25.4373600Z drop cascades to table enterprise_emails
2020-11-15T22:53:25.4374280Z drop cascades to table episode_progresses
2020-11-15T22:53:25.4374730Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:25.4375130Z drop cascades to sequence test_uuids
2020-11-15T22:53:25.4375500Z drop cascades to sequence test_shortids
2020-11-15T22:53:26.5399580Z 2020-11-15T22:53:26+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 6E51D3F5-CC8B-47A5-AADE-508E6E6C63CC [Request] GET /newsletters/express-unsubscribe
2020-11-15T22:53:26.6148970Z 2020-11-15T22:53:26+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 6E51D3F5-CC8B-47A5-AADE-508E6E6C63CC [Time] 70ms
2020-11-15T22:53:26.6244430Z Test Case '-[PointFreeTests.NewslettersIntegrationTests testExpressUnsubscribe]' passed (1.204 seconds).
2020-11-15T22:53:26.6246450Z Test Case '-[PointFreeTests.NewslettersIntegrationTests testExpressUnsubscribeReply]' started.
2020-11-15T22:53:26.6401350Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:26.6402540Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:26.6405440Z drop cascades to extension uuid-ossp
2020-11-15T22:53:26.6406670Z drop cascades to extension citext
2020-11-15T22:53:26.6407250Z drop cascades to table users
2020-11-15T22:53:26.6407860Z drop cascades to table subscriptions
2020-11-15T22:53:26.6408470Z drop cascades to table team_invites
2020-11-15T22:53:26.6409490Z drop cascades to table email_settings
2020-11-15T22:53:26.6414130Z drop cascades to table episode_credits
2020-11-15T22:53:26.6414510Z drop cascades to table feed_request_events
2020-11-15T22:53:26.6414930Z drop cascades to function update_updated_at()
2020-11-15T22:53:26.6416650Z drop cascades to table enterprise_accounts
2020-11-15T22:53:26.6417060Z drop cascades to table enterprise_emails
2020-11-15T22:53:26.6417460Z drop cascades to table episode_progresses
2020-11-15T22:53:26.6417880Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:26.6418810Z drop cascades to sequence test_uuids
2020-11-15T22:53:26.6419200Z drop cascades to sequence test_shortids
2020-11-15T22:53:27.7611830Z 2020-11-15T22:53:27+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 144FCD01-15B2-47DB-8810-EF3FB8A03F7C [Request] POST /newsletters/express-unsubscribe-reply
2020-11-15T22:53:27.8103460Z 2020-11-15T22:53:27+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 144FCD01-15B2-47DB-8810-EF3FB8A03F7C [Time] 49ms
2020-11-15T22:53:27.8193670Z Test Case '-[PointFreeTests.NewslettersIntegrationTests testExpressUnsubscribeReply]' passed (1.195 seconds).
2020-11-15T22:53:27.8195860Z Test Case '-[PointFreeTests.NewslettersIntegrationTests testExpressUnsubscribeReply_IncorrectSignature]' started.
2020-11-15T22:53:27.8331410Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:27.8331970Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:27.8333150Z drop cascades to extension uuid-ossp
2020-11-15T22:53:27.8333530Z drop cascades to extension citext
2020-11-15T22:53:27.8333870Z drop cascades to table users
2020-11-15T22:53:27.8334220Z drop cascades to table subscriptions
2020-11-15T22:53:27.8334600Z drop cascades to table team_invites
2020-11-15T22:53:27.8334940Z drop cascades to table email_settings
2020-11-15T22:53:27.8335310Z drop cascades to table episode_credits
2020-11-15T22:53:27.8335810Z drop cascades to table feed_request_events
2020-11-15T22:53:27.8336210Z drop cascades to function update_updated_at()
2020-11-15T22:53:27.8336630Z drop cascades to table enterprise_accounts
2020-11-15T22:53:27.8337030Z drop cascades to table enterprise_emails
2020-11-15T22:53:27.8337420Z drop cascades to table episode_progresses
2020-11-15T22:53:27.8337830Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:27.8338650Z drop cascades to sequence test_uuids
2020-11-15T22:53:27.8339070Z drop cascades to sequence test_shortids
2020-11-15T22:53:28.9445690Z 2020-11-15T22:53:28+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 31D31D46-1D25-4B39-8E39-B3C785662D97 [Request] POST /newsletters/express-unsubscribe-reply
2020-11-15T22:53:28.9459750Z 2020-11-15T22:53:28+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 31D31D46-1D25-4B39-8E39-B3C785662D97 [Time] 1ms
2020-11-15T22:53:28.9550130Z Test Case '-[PointFreeTests.NewslettersIntegrationTests testExpressUnsubscribeReply_IncorrectSignature]' passed (1.136 seconds).
2020-11-15T22:53:28.9552830Z Test Case '-[PointFreeTests.NewslettersIntegrationTests testExpressUnsubscribeReply_UnknownNewsletter]' started.
2020-11-15T22:53:28.9682160Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:28.9682720Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:28.9683820Z drop cascades to extension uuid-ossp
2020-11-15T22:53:28.9684210Z drop cascades to extension citext
2020-11-15T22:53:28.9684530Z drop cascades to table users
2020-11-15T22:53:28.9684890Z drop cascades to table subscriptions
2020-11-15T22:53:28.9685250Z drop cascades to table team_invites
2020-11-15T22:53:28.9685610Z drop cascades to table email_settings
2020-11-15T22:53:28.9685970Z drop cascades to table episode_credits
2020-11-15T22:53:28.9686350Z drop cascades to table feed_request_events
2020-11-15T22:53:28.9686740Z drop cascades to function update_updated_at()
2020-11-15T22:53:28.9687160Z drop cascades to table enterprise_accounts
2020-11-15T22:53:28.9687550Z drop cascades to table enterprise_emails
2020-11-15T22:53:28.9687950Z drop cascades to table episode_progresses
2020-11-15T22:53:28.9688360Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:28.9688750Z drop cascades to sequence test_uuids
2020-11-15T22:53:28.9689120Z drop cascades to sequence test_shortids
2020-11-15T22:53:29.9633120Z 2020-11-15T22:53:29+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 7E6DDFCF-30B2-4632-8CB5-472C87D8C476 [Request] POST /newsletters/express-unsubscribe-reply
2020-11-15T22:53:29.9644610Z 2020-11-15T22:53:29+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 7E6DDFCF-30B2-4632-8CB5-472C87D8C476 [Time] 1ms
2020-11-15T22:53:29.9737670Z Test Case '-[PointFreeTests.NewslettersIntegrationTests testExpressUnsubscribeReply_UnknownNewsletter]' passed (1.019 seconds).
2020-11-15T22:53:29.9741780Z Test Suite 'NewslettersIntegrationTests' passed at 2020-11-15 22:53:29.973.
2020-11-15T22:53:29.9745230Z    Executed 4 tests, with 0 failures (0 unexpected) in 4.553 (4.554) seconds
2020-11-15T22:53:29.9747200Z Test Suite 'NotFoundMiddlewareTests' started at 2020-11-15 22:53:29.974
2020-11-15T22:53:29.9748490Z Test Case '-[PointFreeTests.NotFoundMiddlewareTests testNotFound]' started.
2020-11-15T22:53:29.9759330Z 2020-11-15T22:53:29+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift A246C68D-FCFC-4113-B894-A1C596616A6A [Request] GET /404
2020-11-15T22:53:30.0050750Z 2020-11-15T22:53:30+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 A246C68D-FCFC-4113-B894-A1C596616A6A [Time] 29ms
2020-11-15T22:53:30.0059620Z Test Case '-[PointFreeTests.NotFoundMiddlewareTests testNotFound]' passed (0.032 seconds).
2020-11-15T22:53:30.0061460Z Test Case '-[PointFreeTests.NotFoundMiddlewareTests testNotFound_LoggedIn]' started.
2020-11-15T22:53:30.0081890Z 2020-11-15T22:53:30+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift B9997531-FCB2-490B-BF63-6AD0275C24BA [Request] GET /404
2020-11-15T22:53:30.0363040Z 2020-11-15T22:53:30+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 B9997531-FCB2-490B-BF63-6AD0275C24BA [Time] 28ms
2020-11-15T22:53:30.0373190Z Test Case '-[PointFreeTests.NotFoundMiddlewareTests testNotFound_LoggedIn]' passed (0.031 seconds).
2020-11-15T22:53:30.0374540Z Test Suite 'NotFoundMiddlewareTests' passed at 2020-11-15 22:53:30.037.
2020-11-15T22:53:30.0375100Z    Executed 2 tests, with 0 failures (0 unexpected) in 0.064 (0.064) seconds
2020-11-15T22:53:30.0375930Z Test Suite 'PaymentInfoTests' started at 2020-11-15 22:53:30.037
2020-11-15T22:53:30.0377470Z Test Case '-[PointFreeTests.PaymentInfoTests testInvoiceBilling]' started.
2020-11-15T22:53:30.0395760Z 2020-11-15T22:53:30+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 A726F62B-6736-4421-8E6D-DAD047579D53 [Request] GET /account/payment-info
2020-11-15T22:53:30.0419180Z 2020-11-15T22:53:30+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 A726F62B-6736-4421-8E6D-DAD047579D53 [Time] 2ms
2020-11-15T22:53:30.0425200Z Test Case '-[PointFreeTests.PaymentInfoTests testInvoiceBilling]' passed (0.005 seconds).
2020-11-15T22:53:30.0426530Z Test Case '-[PointFreeTests.PaymentInfoTests testRender]' started.
2020-11-15T22:53:30.0446570Z 2020-11-15T22:53:30+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 AE961DA6-4F95-4BBC-ABFB-465BABA36411 [Request] GET /account/payment-info
2020-11-15T22:53:30.0741730Z 2020-11-15T22:53:30+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 AE961DA6-4F95-4BBC-ABFB-465BABA36411 [Time] 29ms
2020-11-15T22:53:30.0751820Z Test Case '-[PointFreeTests.PaymentInfoTests testRender]' passed (0.033 seconds).
2020-11-15T22:53:30.0752940Z Test Suite 'PaymentInfoTests' passed at 2020-11-15 22:53:30.075.
2020-11-15T22:53:30.0753430Z    Executed 2 tests, with 0 failures (0 unexpected) in 0.038 (0.038) seconds
2020-11-15T22:53:30.0754290Z Test Suite 'PointFreeRouterTests' started at 2020-11-15 22:53:30.075
2020-11-15T22:53:30.0755620Z Test Case '-[PointFreeRouterTests.PointFreeRouterTests testEpisodeProgressRoute]' started.
2020-11-15T22:53:30.0771000Z Test Case '-[PointFreeRouterTests.PointFreeRouterTests testEpisodeProgressRoute]' passed (0.002 seconds).
2020-11-15T22:53:30.0772840Z Test Case '-[PointFreeRouterTests.PointFreeRouterTests testEpisodeShowRoute]' started.
2020-11-15T22:53:30.0786150Z Test Case '-[PointFreeRouterTests.PointFreeRouterTests testEpisodeShowRoute]' passed (0.001 seconds).
2020-11-15T22:53:30.0787900Z Test Case '-[PointFreeRouterTests.PointFreeRouterTests testSubscribeRoute]' started.
2020-11-15T22:53:30.0830870Z Test Case '-[PointFreeRouterTests.PointFreeRouterTests testSubscribeRoute]' passed (0.005 seconds).
2020-11-15T22:53:30.0832570Z Test Case '-[PointFreeRouterTests.PointFreeRouterTests testTeamJoin]' started.
2020-11-15T22:53:30.0855480Z Test Case '-[PointFreeRouterTests.PointFreeRouterTests testTeamJoin]' passed (0.002 seconds).
2020-11-15T22:53:30.0857540Z Test Case '-[PointFreeRouterTests.PointFreeRouterTests testTeamJoinLanding]' started.
2020-11-15T22:53:30.0880780Z Test Case '-[PointFreeRouterTests.PointFreeRouterTests testTeamJoinLanding]' passed (0.002 seconds).
2020-11-15T22:53:30.0882530Z Test Case '-[PointFreeRouterTests.PointFreeRouterTests testUpdateProfile]' started.
2020-11-15T22:53:30.0901760Z Test Case '-[PointFreeRouterTests.PointFreeRouterTests testUpdateProfile]' passed (0.002 seconds).
2020-11-15T22:53:30.0903140Z Test Suite 'PointFreeRouterTests' passed at 2020-11-15 22:53:30.090.
2020-11-15T22:53:30.0904180Z    Executed 6 tests, with 0 failures (0 unexpected) in 0.015 (0.015) seconds
2020-11-15T22:53:30.0905270Z Test Suite 'PricingLandingIntegrationTests' started at 2020-11-15 22:53:30.090
2020-11-15T22:53:30.0906830Z Test Case '-[PointFreeTests.PricingLandingIntegrationTests testLanding_LoggedIn_InactiveSubscriber]' started.
2020-11-15T22:53:30.1035910Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:30.1036450Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:30.1037620Z drop cascades to extension uuid-ossp
2020-11-15T22:53:30.1037990Z drop cascades to extension citext
2020-11-15T22:53:30.1038330Z drop cascades to table users
2020-11-15T22:53:30.1038680Z drop cascades to table subscriptions
2020-11-15T22:53:30.1039520Z drop cascades to table team_invites
2020-11-15T22:53:30.1039880Z drop cascades to table email_settings
2020-11-15T22:53:30.1040240Z drop cascades to table episode_credits
2020-11-15T22:53:30.1040620Z drop cascades to table feed_request_events
2020-11-15T22:53:30.1041010Z drop cascades to function update_updated_at()
2020-11-15T22:53:30.1041420Z drop cascades to table enterprise_accounts
2020-11-15T22:53:30.1041830Z drop cascades to table enterprise_emails
2020-11-15T22:53:30.1042220Z drop cascades to table episode_progresses
2020-11-15T22:53:30.1042640Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:30.1043030Z drop cascades to sequence test_uuids
2020-11-15T22:53:30.1043400Z drop cascades to sequence test_shortids
2020-11-15T22:53:31.1197180Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 58B4D2CF-A2C7-446D-B8CF-5BA9DAA07BB5 [Request] GET /pricing
2020-11-15T22:53:31.2004490Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 58B4D2CF-A2C7-446D-B8CF-5BA9DAA07BB5 [Time] 80ms
2020-11-15T22:53:31.2032320Z Test Case '-[PointFreeTests.PricingLandingIntegrationTests testLanding_LoggedIn_InactiveSubscriber]' passed (1.112 seconds).
2020-11-15T22:53:31.2035410Z Test Suite 'PricingLandingIntegrationTests' passed at 2020-11-15 22:53:31.203.
2020-11-15T22:53:31.2036060Z    Executed 1 test, with 0 failures (0 unexpected) in 1.112 (1.113) seconds
2020-11-15T22:53:31.2036920Z Test Suite 'PricingLandingTests' started at 2020-11-15 22:53:31.203
2020-11-15T22:53:31.2038130Z Test Case '-[PointFreeTests.PricingLandingTests testLanding_LoggedIn_ActiveSubscriber]' started.
2020-11-15T22:53:31.2048060Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 4C992ED8-B4DC-47F0-AEF1-295BCAAA6870 [Request] GET /pricing
2020-11-15T22:53:31.2519840Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 4C992ED8-B4DC-47F0-AEF1-295BCAAA6870 [Time] 46ms
2020-11-15T22:53:31.2535900Z Test Case '-[PointFreeTests.PricingLandingTests testLanding_LoggedIn_ActiveSubscriber]' passed (0.051 seconds).
2020-11-15T22:53:31.2537520Z Test Case '-[PointFreeTests.PricingLandingTests testLanding_LoggedOut]' started.
2020-11-15T22:53:31.2557210Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 9E4CD0D2-3599-4660-9A3A-B3B1B3A6D03A [Request] GET /pricing
2020-11-15T22:53:31.3180200Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 9E4CD0D2-3599-4660-9A3A-B3B1B3A6D03A [Time] 62ms
2020-11-15T22:53:31.3196220Z Test Case '-[PointFreeTests.PricingLandingTests testLanding_LoggedOut]' passed (0.066 seconds).
2020-11-15T22:53:31.3197470Z Test Suite 'PricingLandingTests' passed at 2020-11-15 22:53:31.319.
2020-11-15T22:53:31.3197990Z    Executed 2 tests, with 0 failures (0 unexpected) in 0.117 (0.117) seconds
2020-11-15T22:53:31.3199180Z Test Suite 'PrivacyTests' started at 2020-11-15 22:53:31.320
2020-11-15T22:53:31.3200200Z Test Case '-[PointFreeTests.PrivacyTests testPrivacy]' started.
2020-11-15T22:53:31.3217950Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 E9FE3397-4DF8-4FEE-8E34-6FCF36232B85 [Request] GET /privacy
2020-11-15T22:53:31.3526940Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 E9FE3397-4DF8-4FEE-8E34-6FCF36232B85 [Time] 30ms
2020-11-15T22:53:31.3535950Z Test Case '-[PointFreeTests.PrivacyTests testPrivacy]' passed (0.034 seconds).
2020-11-15T22:53:31.3537010Z Test Suite 'PrivacyTests' passed at 2020-11-15 22:53:31.353.
2020-11-15T22:53:31.3537460Z    Executed 1 test, with 0 failures (0 unexpected) in 0.034 (0.034) seconds
2020-11-15T22:53:31.3538290Z Test Suite 'PrivateRssTests' started at 2020-11-15 22:53:31.354
2020-11-15T22:53:31.3539480Z Test Case '-[PointFreeTests.PrivateRssTests testFeed_Authenticated_DeactivatedSubscriber]' started.
2020-11-15T22:53:31.3569660Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 C099F60A-083F-44FD-879D-0BCA65505659 [Request] GET /account/rss/f9c46e50cb32c3f12369e92c8bb9d9db09edf2cce5a0307b4e8516ac36340b47847c7d6d216c635dd0cff1d0429f0567/6f19da772a4f375a88d7fa153b38da002839db602c2dab23f1a9524dcfb37f8498e27e463f4da28c1cf14a06cbd6d07a
2020-11-15T22:53:31.3594250Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift C099F60A-083F-44FD-879D-0BCA65505659 [Time] 2ms
2020-11-15T22:53:31.3599690Z Test Case '-[PointFreeTests.PrivateRssTests testFeed_Authenticated_DeactivatedSubscriber]' passed (0.006 seconds).
2020-11-15T22:53:31.3601280Z Test Case '-[PointFreeTests.PrivateRssTests testFeed_Authenticated_InActiveSubscriber]' started.
2020-11-15T22:53:31.3630260Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 DE081278-AF9A-49C5-9567-787B0336D32E [Request] GET /account/rss/f9c46e50cb32c3f12369e92c8bb9d9db09edf2cce5a0307b4e8516ac36340b47847c7d6d216c635dd0cff1d0429f0567/6f19da772a4f375a88d7fa153b38da002839db602c2dab23f1a9524dcfb37f8498e27e463f4da28c1cf14a06cbd6d07a
2020-11-15T22:53:31.3646900Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift DE081278-AF9A-49C5-9567-787B0336D32E [Time] 1ms
2020-11-15T22:53:31.3652320Z Test Case '-[PointFreeTests.PrivateRssTests testFeed_Authenticated_InActiveSubscriber]' passed (0.005 seconds).
2020-11-15T22:53:31.3653810Z Test Case '-[PointFreeTests.PrivateRssTests testFeed_Authenticated_NonSubscriber]' started.
2020-11-15T22:53:31.3682950Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 071064E2-415B-47D1-9FC6-64099917BDCF [Request] GET /account/rss/f9c46e50cb32c3f12369e92c8bb9d9db09edf2cce5a0307b4e8516ac36340b47847c7d6d216c635dd0cff1d0429f0567/6f19da772a4f375a88d7fa153b38da002839db602c2dab23f1a9524dcfb37f8498e27e463f4da28c1cf14a06cbd6d07a
2020-11-15T22:53:31.3699580Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 071064E2-415B-47D1-9FC6-64099917BDCF [Time] 1ms
2020-11-15T22:53:31.3704880Z Test Case '-[PointFreeTests.PrivateRssTests testFeed_Authenticated_NonSubscriber]' passed (0.005 seconds).
2020-11-15T22:53:31.3706350Z Test Case '-[PointFreeTests.PrivateRssTests testFeed_Authenticated_Subscriber_Monthly]' started.
2020-11-15T22:53:31.3738600Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 F80A2B73-86CF-44BA-BEA4-927FA5ECA9A6 [Request] GET /account/rss/f9c46e50cb32c3f12369e92c8bb9d9db09edf2cce5a0307b4e8516ac36340b47847c7d6d216c635dd0cff1d0429f0567/6f19da772a4f375a88d7fa153b38da002839db602c2dab23f1a9524dcfb37f8498e27e463f4da28c1cf14a06cbd6d07a
2020-11-15T22:53:31.3832860Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 F80A2B73-86CF-44BA-BEA4-927FA5ECA9A6 [Time] 9ms
2020-11-15T22:53:31.3839010Z Test Case '-[PointFreeTests.PrivateRssTests testFeed_Authenticated_Subscriber_Monthly]' passed (0.013 seconds).
2020-11-15T22:53:31.3840840Z Test Case '-[PointFreeTests.PrivateRssTests testFeed_Authenticated_Subscriber_Yearly]' started.
2020-11-15T22:53:31.3870080Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift B0764081-205D-4432-A36C-90F4B58D3C68 [Request] GET /account/rss/f9c46e50cb32c3f12369e92c8bb9d9db09edf2cce5a0307b4e8516ac36340b47847c7d6d216c635dd0cff1d0429f0567/6f19da772a4f375a88d7fa153b38da002839db602c2dab23f1a9524dcfb37f8498e27e463f4da28c1cf14a06cbd6d07a
2020-11-15T22:53:31.3983690Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 B0764081-205D-4432-A36C-90F4B58D3C68 [Time] 11ms
2020-11-15T22:53:31.3989730Z Test Case '-[PointFreeTests.PrivateRssTests testFeed_Authenticated_Subscriber_Yearly]' passed (0.015 seconds).
2020-11-15T22:53:31.3991080Z Test Case '-[PointFreeTests.PrivateRssTests testFeed_BadSalt]' started.
2020-11-15T22:53:31.4021440Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 4E4EBBAA-82C7-455E-AA1E-D7F03F3557E9 [Request] GET /account/rss/f9c46e50cb32c3f12369e92c8bb9d9db09edf2cce5a0307b4e8516ac36340b47847c7d6d216c635dd0cff1d0429f0567/a1c680c38d3e5791f6fdf120fc5c55f4e2a11e8f457168064e770c67058c8f1ada90a08da9c299d7a52e5e593ecb63a8
2020-11-15T22:53:31.4040060Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 4E4EBBAA-82C7-455E-AA1E-D7F03F3557E9 [Time] 2ms
2020-11-15T22:53:31.4045000Z Test Case '-[PointFreeTests.PrivateRssTests testFeed_BadSalt]' passed (0.005 seconds).
2020-11-15T22:53:31.4046400Z Test Case '-[PointFreeTests.PrivateRssTests testFeed_BadSalt_InvalidUserAgent]' started.
2020-11-15T22:53:31.4075850Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 128A292E-FD70-435C-AC0C-1D83A5F8F371 [Request] GET /account/rss/f9c46e50cb32c3f12369e92c8bb9d9db09edf2cce5a0307b4e8516ac36340b47847c7d6d216c635dd0cff1d0429f0567/a1c680c38d3e5791f6fdf120fc5c55f4e2a11e8f457168064e770c67058c8f1ada90a08da9c299d7a52e5e593ecb63a8
2020-11-15T22:53:31.4094710Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 128A292E-FD70-435C-AC0C-1D83A5F8F371 [Time] 2ms
2020-11-15T22:53:31.4100050Z Test Case '-[PointFreeTests.PrivateRssTests testFeed_BadSalt_InvalidUserAgent]' passed (0.005 seconds).
2020-11-15T22:53:31.4101480Z Test Case '-[PointFreeTests.PrivateRssTests testFeed_InvalidUserAgent]' started.
2020-11-15T22:53:31.4131510Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 00AAE330-3C26-4633-BE10-3D16CE3C80FE [Request] GET /account/rss/f9c46e50cb32c3f12369e92c8bb9d9db09edf2cce5a0307b4e8516ac36340b47847c7d6d216c635dd0cff1d0429f0567/6f19da772a4f375a88d7fa153b38da002839db602c2dab23f1a9524dcfb37f8498e27e463f4da28c1cf14a06cbd6d07a
2020-11-15T22:53:31.4150340Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 00AAE330-3C26-4633-BE10-3D16CE3C80FE [Time] 2ms
2020-11-15T22:53:31.4155790Z Test Case '-[PointFreeTests.PrivateRssTests testFeed_InvalidUserAgent]' passed (0.006 seconds).
2020-11-15T22:53:31.4157180Z Test Case '-[PointFreeTests.PrivateRssTests testFeed_ValidUserAgent]' started.
2020-11-15T22:53:31.4190270Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 4FDFE1BE-7392-416C-8C8A-36793EDDC5B5 [Request] GET /account/rss/f9c46e50cb32c3f12369e92c8bb9d9db09edf2cce5a0307b4e8516ac36340b47847c7d6d216c635dd0cff1d0429f0567/6f19da772a4f375a88d7fa153b38da002839db602c2dab23f1a9524dcfb37f8498e27e463f4da28c1cf14a06cbd6d07a
2020-11-15T22:53:31.4287680Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 4FDFE1BE-7392-416C-8C8A-36793EDDC5B5 [Time] 9ms
2020-11-15T22:53:31.4293640Z Test Case '-[PointFreeTests.PrivateRssTests testFeed_ValidUserAgent]' passed (0.014 seconds).
2020-11-15T22:53:31.4294800Z Test Suite 'PrivateRssTests' passed at 2020-11-15 22:53:31.429.
2020-11-15T22:53:31.4295280Z    Executed 9 tests, with 0 failures (0 unexpected) in 0.075 (0.076) seconds
2020-11-15T22:53:31.4296130Z Test Suite 'ReferralEmailTests' started at 2020-11-15 22:53:31.429
2020-11-15T22:53:31.4297230Z Test Case '-[PointFreeTests.ReferralEmailTests testReferralEmail]' started.
2020-11-15T22:53:31.4735880Z Test Case '-[PointFreeTests.ReferralEmailTests testReferralEmail]' passed (0.044 seconds).
2020-11-15T22:53:31.4737540Z Test Suite 'ReferralEmailTests' passed at 2020-11-15 22:53:31.473.
2020-11-15T22:53:31.4738130Z    Executed 1 test, with 0 failures (0 unexpected) in 0.044 (0.044) seconds
2020-11-15T22:53:31.4739140Z Test Suite 'RegistrationEmailTests' started at 2020-11-15 22:53:31.473
2020-11-15T22:53:31.4740480Z Test Case '-[PointFreeTests.RegistrationEmailTests testRegistrationEmail]' started.
2020-11-15T22:53:31.5224500Z Test Case '-[PointFreeTests.RegistrationEmailTests testRegistrationEmail]' passed (0.049 seconds).
2020-11-15T22:53:31.5232350Z Test Suite 'RegistrationEmailTests' passed at 2020-11-15 22:53:31.522.
2020-11-15T22:53:31.5232910Z    Executed 1 test, with 0 failures (0 unexpected) in 0.049 (0.049) seconds
2020-11-15T22:53:31.5233740Z Test Suite 'SessionTests' started at 2020-11-15 22:53:31.522
2020-11-15T22:53:31.5234680Z Test Case '-[PointFreeTests.SessionTests testDecodable]' started.
2020-11-15T22:53:31.5249570Z Test Case '-[PointFreeTests.SessionTests testDecodable]' passed (0.002 seconds).
2020-11-15T22:53:31.5250780Z Test Case '-[PointFreeTests.SessionTests testEncodable]' started.
2020-11-15T22:53:31.5276420Z Test Case '-[PointFreeTests.SessionTests testEncodable]' passed (0.003 seconds).
2020-11-15T22:53:31.5277520Z Test Suite 'SessionTests' passed at 2020-11-15 22:53:31.527.
2020-11-15T22:53:31.5277970Z    Executed 2 tests, with 0 failures (0 unexpected) in 0.005 (0.005) seconds
2020-11-15T22:53:31.5278850Z Test Suite 'SiteMiddlewareTests' started at 2020-11-15 22:53:31.528
2020-11-15T22:53:31.5279960Z Test Case '-[PointFreeTests.SiteMiddlewareTests testWithHttps]' started.
2020-11-15T22:53:31.5298370Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 044AB434-F185-412B-B869-354D85E48C78 [Request] GET
2020-11-15T22:53:31.5301260Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 044AB434-F185-412B-B869-354D85E48C78 [Time] 0ms
2020-11-15T22:53:31.5309940Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 86FEB890-9650-4821-B4DD-6C0FE5E46FF4 [Request] GET /episodes
2020-11-15T22:53:31.5312680Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 86FEB890-9650-4821-B4DD-6C0FE5E46FF4 [Time] 0ms
2020-11-15T22:53:31.5318320Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 324E9806-438E-471D-A6A7-0228CF80FD52 [Request] GET /
2020-11-15T22:53:31.5729540Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 324E9806-438E-471D-A6A7-0228CF80FD52 [Time] 40ms
2020-11-15T22:53:31.5763320Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 DFB1EF9C-C41E-4082-A5BB-A3BC4AAE44C2 [Request] GET /
2020-11-15T22:53:31.6165040Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 DFB1EF9C-C41E-4082-A5BB-A3BC4AAE44C2 [Time] 41ms
2020-11-15T22:53:31.6173830Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 0D5FC19B-90B6-419D-B5C6-985B67478DE5 [Request] GET /
2020-11-15T22:53:31.6593010Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 0D5FC19B-90B6-419D-B5C6-985B67478DE5 [Time] 41ms
2020-11-15T22:53:31.6608610Z Test Case '-[PointFreeTests.SiteMiddlewareTests testWithHttps]' passed (0.133 seconds).
2020-11-15T22:53:31.6610160Z Test Case '-[PointFreeTests.SiteMiddlewareTests testWithoutHeroku]' started.
2020-11-15T22:53:31.6628390Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 4233473F-5FB0-44D0-85F3-DAFF0B5B5D0A [Request] GET
2020-11-15T22:53:31.6630860Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 4233473F-5FB0-44D0-85F3-DAFF0B5B5D0A [Time] 0ms
2020-11-15T22:53:31.6639260Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 16F914E5-CE47-4D2C-AC5F-1370050E588A [Request] GET /episodes
2020-11-15T22:53:31.6642440Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 16F914E5-CE47-4D2C-AC5F-1370050E588A [Time] 0ms
2020-11-15T22:53:31.6645950Z Test Case '-[PointFreeTests.SiteMiddlewareTests testWithoutHeroku]' passed (0.004 seconds).
2020-11-15T22:53:31.6647530Z Test Case '-[PointFreeTests.SiteMiddlewareTests testWithoutWWW]' started.
2020-11-15T22:53:31.6663900Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 41BC104A-46AF-4F5F-AB8E-01C3DCBFB00D [Request] GET
2020-11-15T22:53:31.6666230Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 41BC104A-46AF-4F5F-AB8E-01C3DCBFB00D [Time] 0ms
2020-11-15T22:53:31.6673880Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 26B9A42A-74A3-488C-B45C-F1F05475DE43 [Request] GET /episodes
2020-11-15T22:53:31.6676860Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 26B9A42A-74A3-488C-B45C-F1F05475DE43 [Time] 0ms
2020-11-15T22:53:31.6680810Z Test Case '-[PointFreeTests.SiteMiddlewareTests testWithoutWWW]' passed (0.003 seconds).
2020-11-15T22:53:31.6682210Z Test Case '-[PointFreeTests.SiteMiddlewareTests testWithWWW]' started.
2020-11-15T22:53:31.6699480Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 BF54FDEE-1172-4C5E-AFEE-4CAF2A11D8A3 [Request] GET
2020-11-15T22:53:31.7105870Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift BF54FDEE-1172-4C5E-AFEE-4CAF2A11D8A3 [Time] 39ms
2020-11-15T22:53:31.7130210Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift F1DF9ED2-4146-4F67-AFC7-125162D54A79 [Request] GET
2020-11-15T22:53:31.7524830Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift F1DF9ED2-4146-4F67-AFC7-125162D54A79 [Time] 40ms
2020-11-15T22:53:31.7533080Z Test Case '-[PointFreeTests.SiteMiddlewareTests testWithWWW]' passed (0.085 seconds).
2020-11-15T22:53:31.7534290Z Test Suite 'SiteMiddlewareTests' passed at 2020-11-15 22:53:31.753.
2020-11-15T22:53:31.7534800Z    Executed 4 tests, with 0 failures (0 unexpected) in 0.225 (0.226) seconds
2020-11-15T22:53:31.7535600Z Test Suite 'StripeTests' started at 2020-11-15 22:53:31.753
2020-11-15T22:53:31.7536570Z Test Case '-[StripeTests.StripeTests testDecodingCustomer_Metadata]' started.
2020-11-15T22:53:31.7543200Z Test Case '-[StripeTests.StripeTests testDecodingCustomer_Metadata]' passed (0.001 seconds).
2020-11-15T22:53:31.7544470Z Test Case '-[StripeTests.StripeTests testDecodingCustomer]' started.
2020-11-15T22:53:31.7546830Z Test Case '-[StripeTests.StripeTests testDecodingCustomer]' passed (0.000 seconds).
2020-11-15T22:53:31.7548260Z Test Case '-[StripeTests.StripeTests testDecodingDiscountJson]' started.
2020-11-15T22:53:31.7558270Z Test Case '-[StripeTests.StripeTests testDecodingDiscountJson]' passed (0.001 seconds).
2020-11-15T22:53:31.7559540Z Test Case '-[StripeTests.StripeTests testDecodingPlan_WithNickname]' started.
2020-11-15T22:53:31.7563660Z Test Case '-[StripeTests.StripeTests testDecodingPlan_WithNickname]' passed (0.000 seconds).
2020-11-15T22:53:31.7564940Z Test Case '-[StripeTests.StripeTests testDecodingPlan_WithoutNickname]' started.
2020-11-15T22:53:31.7567180Z Test Case '-[StripeTests.StripeTests testDecodingPlan_WithoutNickname]' passed (0.000 seconds).
2020-11-15T22:53:31.7568740Z Test Case '-[StripeTests.StripeTests testDecodingSubscriptionWithDiscount]' started.
2020-11-15T22:53:31.7581070Z Test Case '-[StripeTests.StripeTests testDecodingSubscriptionWithDiscount]' passed (0.001 seconds).
2020-11-15T22:53:31.7582450Z Test Case '-[StripeTests.StripeTests testRequests]' started.
2020-11-15T22:53:31.7692840Z Test Case '-[StripeTests.StripeTests testRequests]' passed (0.011 seconds).
2020-11-15T22:53:31.7693910Z Test Suite 'StripeTests' passed at 2020-11-15 22:53:31.769.
2020-11-15T22:53:31.7694370Z    Executed 7 tests, with 0 failures (0 unexpected) in 0.015 (0.016) seconds
2020-11-15T22:53:31.7695240Z Test Suite 'StripeWebhooksTests' started at 2020-11-15 22:53:31.769
2020-11-15T22:53:31.7696340Z Test Case '-[PointFreeTests.StripeWebhooksTests testDecoding]' started.
2020-11-15T22:53:31.7729280Z Test Case '-[PointFreeTests.StripeWebhooksTests testDecoding]' passed (0.004 seconds).
2020-11-15T22:53:31.7730760Z Test Case '-[PointFreeTests.StripeWebhooksTests testInvalidHook]' started.
2020-11-15T22:53:31.7883250Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 3E7379A1-1712-48E8-AFE5-563D1183DB38 [Request] POST /webhooks/stripe
2020-11-15T22:53:31.7907820Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 3E7379A1-1712-48E8-AFE5-563D1183DB38 [Time] 2ms
2020-11-15T22:53:31.7914420Z Test Case '-[PointFreeTests.StripeWebhooksTests testInvalidHook]' passed (0.018 seconds).
2020-11-15T22:53:31.7915950Z Test Case '-[PointFreeTests.StripeWebhooksTests testNoInvoiceNumber]' started.
2020-11-15T22:53:31.8046180Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 976B2E7D-081F-4A71-8DBA-9FEADAB9C8EF [Request] POST /webhooks/stripe
2020-11-15T22:53:31.8061840Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 976B2E7D-081F-4A71-8DBA-9FEADAB9C8EF [Time] 1ms
2020-11-15T22:53:31.8067450Z Test Case '-[PointFreeTests.StripeWebhooksTests testNoInvoiceNumber]' passed (0.015 seconds).
2020-11-15T22:53:31.8069060Z Test Case '-[PointFreeTests.StripeWebhooksTests testNoInvoiceSubscriptionId]' started.
2020-11-15T22:53:31.8188250Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 A5A69268-A020-4D3A-B5E4-A6B7F7155A91 [Request] POST /webhooks/stripe
2020-11-15T22:53:31.8205660Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift A5A69268-A020-4D3A-B5E4-A6B7F7155A91 [Time] 1ms
2020-11-15T22:53:31.8211920Z Test Case '-[PointFreeTests.StripeWebhooksTests testNoInvoiceSubscriptionId]' passed (0.014 seconds).
2020-11-15T22:53:31.8213880Z Test Case '-[PointFreeTests.StripeWebhooksTests testNoInvoiceSubscriptionId_AndNoLineItemSubscriptionId]' started.
2020-11-15T22:53:31.8330820Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 17A4D825-C0EC-4C7E-8C94-265989880E73 [Request] POST /webhooks/stripe
2020-11-15T22:53:31.8347970Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 17A4D825-C0EC-4C7E-8C94-265989880E73 [Time] 1ms
2020-11-15T22:53:31.8354580Z Test Case '-[PointFreeTests.StripeWebhooksTests testNoInvoiceSubscriptionId_AndNoLineItemSubscriptionId]' passed (0.014 seconds).
2020-11-15T22:53:31.8356390Z Test Case '-[PointFreeTests.StripeWebhooksTests testPastDueEmail]' started.
2020-11-15T22:53:31.8821520Z Test Case '-[PointFreeTests.StripeWebhooksTests testPastDueEmail]' passed (0.047 seconds).
2020-11-15T22:53:31.8823060Z Test Case '-[PointFreeTests.StripeWebhooksTests testStaleHook]' started.
2020-11-15T22:53:31.8944290Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 70E29579-9DF8-4EF6-9DA4-C5E5C0C38589 [Request] POST /webhooks/stripe
2020-11-15T22:53:31.8959680Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 70E29579-9DF8-4EF6-9DA4-C5E5C0C38589 [Time] 1ms
2020-11-15T22:53:31.8965700Z Test Case '-[PointFreeTests.StripeWebhooksTests testStaleHook]' passed (0.014 seconds).
2020-11-15T22:53:31.8967110Z Test Case '-[PointFreeTests.StripeWebhooksTests testValidHook]' started.
2020-11-15T22:53:31.9088390Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 13E23F6F-92CE-45AD-9054-9A0930560AF6 [Request] POST /webhooks/stripe
2020-11-15T22:53:31.9104000Z 2020-11-15T22:53:31+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 13E23F6F-92CE-45AD-9054-9A0930560AF6 [Time] 1ms
2020-11-15T22:53:31.9108780Z Test Case '-[PointFreeTests.StripeWebhooksTests testValidHook]' passed (0.014 seconds).
2020-11-15T22:53:31.9110010Z Test Suite 'StripeWebhooksTests' passed at 2020-11-15 22:53:31.911.
2020-11-15T22:53:31.9110530Z    Executed 8 tests, with 0 failures (0 unexpected) in 0.141 (0.142) seconds
2020-11-15T22:53:31.9111350Z Test Suite 'StyleguideTests' started at 2020-11-15 22:53:31.911
2020-11-15T22:53:31.9112380Z Test Case '-[StyleguideTests.StyleguideTests testGitHubLink_Black]' started.
2020-11-15T22:53:31.9300580Z Test Case '-[StyleguideTests.StyleguideTests testGitHubLink_Black]' passed (0.019 seconds).
2020-11-15T22:53:31.9302450Z Test Case '-[StyleguideTests.StyleguideTests testGitHubLink_White]' started.
2020-11-15T22:53:31.9483170Z Test Case '-[StyleguideTests.StyleguideTests testGitHubLink_White]' passed (0.018 seconds).
2020-11-15T22:53:31.9486330Z Test Case '-[StyleguideTests.StyleguideTests testPointFreeStyles]' started.
2020-11-15T22:53:31.9594850Z Test Case '-[StyleguideTests.StyleguideTests testPointFreeStyles]' passed (0.011 seconds).
2020-11-15T22:53:31.9596320Z Test Case '-[StyleguideTests.StyleguideTests testStyleguide]' started.
2020-11-15T22:53:32.0000970Z Test Case '-[StyleguideTests.StyleguideTests testStyleguide]' passed (0.040 seconds).
2020-11-15T22:53:32.0002660Z Test Case '-[StyleguideTests.StyleguideTests testTwitterLink]' started.
2020-11-15T22:53:32.0186140Z Test Case '-[StyleguideTests.StyleguideTests testTwitterLink]' passed (0.019 seconds).
2020-11-15T22:53:32.0187330Z Test Suite 'StyleguideTests' passed at 2020-11-15 22:53:32.018.
2020-11-15T22:53:32.0187840Z    Executed 5 tests, with 0 failures (0 unexpected) in 0.107 (0.108) seconds
2020-11-15T22:53:32.0188760Z Test Suite 'SubscribeIntegrationTests' started at 2020-11-15 22:53:32.018
2020-11-15T22:53:32.0190040Z Test Case '-[PointFreeTests.SubscribeIntegrationTests testCoupon_Individual]' started.
2020-11-15T22:53:32.0364300Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:32.0364820Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:32.0365960Z drop cascades to extension uuid-ossp
2020-11-15T22:53:32.0366350Z drop cascades to extension citext
2020-11-15T22:53:32.0366680Z drop cascades to table users
2020-11-15T22:53:32.0367030Z drop cascades to table subscriptions
2020-11-15T22:53:32.0367390Z drop cascades to table team_invites
2020-11-15T22:53:32.0367750Z drop cascades to table email_settings
2020-11-15T22:53:32.0368120Z drop cascades to table episode_credits
2020-11-15T22:53:32.0368500Z drop cascades to table feed_request_events
2020-11-15T22:53:32.0368900Z drop cascades to function update_updated_at()
2020-11-15T22:53:32.0369320Z drop cascades to table enterprise_accounts
2020-11-15T22:53:32.0369720Z drop cascades to table enterprise_emails
2020-11-15T22:53:32.0370120Z drop cascades to table episode_progresses
2020-11-15T22:53:32.0370530Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:32.0370930Z drop cascades to sequence test_uuids
2020-11-15T22:53:32.0371300Z drop cascades to sequence test_shortids
2020-11-15T22:53:32.6777710Z 2020-11-15T22:53:32+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift AF4211C6-522B-44AD-BC94-968702E471B2 [Request] POST /subscribe
2020-11-15T22:53:32.7708960Z 2020-11-15T22:53:32+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 AF4211C6-522B-44AD-BC94-968702E471B2 [Time] 93ms
2020-11-15T22:53:32.7805840Z Test Case '-[PointFreeTests.SubscribeIntegrationTests testCoupon_Individual]' passed (0.762 seconds).
2020-11-15T22:53:32.7808010Z Test Case '-[PointFreeTests.SubscribeIntegrationTests testCoupon_Team]' started.
2020-11-15T22:53:32.7943960Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:32.7944500Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:32.7945670Z drop cascades to extension uuid-ossp
2020-11-15T22:53:32.7946490Z drop cascades to extension citext
2020-11-15T22:53:32.7946870Z drop cascades to table users
2020-11-15T22:53:32.7947310Z drop cascades to table subscriptions
2020-11-15T22:53:32.7947680Z drop cascades to table team_invites
2020-11-15T22:53:32.7948040Z drop cascades to table email_settings
2020-11-15T22:53:32.7948410Z drop cascades to table episode_credits
2020-11-15T22:53:32.7948780Z drop cascades to table feed_request_events
2020-11-15T22:53:32.7949170Z drop cascades to function update_updated_at()
2020-11-15T22:53:32.7949580Z drop cascades to table enterprise_accounts
2020-11-15T22:53:32.7949980Z drop cascades to table enterprise_emails
2020-11-15T22:53:32.7950610Z drop cascades to table episode_progresses
2020-11-15T22:53:32.7951030Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:32.7951430Z drop cascades to sequence test_uuids
2020-11-15T22:53:32.7951800Z drop cascades to sequence test_shortids
2020-11-15T22:53:33.4662180Z 2020-11-15T22:53:33+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 1F9C34D1-96EC-4054-AB3E-756EC0C74870 [Request] POST /subscribe
2020-11-15T22:53:33.4830860Z 2020-11-15T22:53:33+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 1F9C34D1-96EC-4054-AB3E-756EC0C74870 [Time] 16ms
2020-11-15T22:53:33.4905320Z Test Case '-[PointFreeTests.SubscribeIntegrationTests testCoupon_Team]' passed (0.710 seconds).
2020-11-15T22:53:33.4907030Z Test Case '-[PointFreeTests.SubscribeIntegrationTests testHappyPath]' started.
2020-11-15T22:53:33.5244920Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:33.5245500Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:33.5246660Z drop cascades to extension uuid-ossp
2020-11-15T22:53:33.5247190Z drop cascades to extension citext
2020-11-15T22:53:33.5247540Z drop cascades to table users
2020-11-15T22:53:33.5247900Z drop cascades to table subscriptions
2020-11-15T22:53:33.5248270Z drop cascades to table team_invites
2020-11-15T22:53:33.5248620Z drop cascades to table email_settings
2020-11-15T22:53:33.5248990Z drop cascades to table episode_credits
2020-11-15T22:53:33.5249370Z drop cascades to table feed_request_events
2020-11-15T22:53:33.5249880Z drop cascades to function update_updated_at()
2020-11-15T22:53:33.5250270Z drop cascades to table enterprise_accounts
2020-11-15T22:53:33.5250670Z drop cascades to table enterprise_emails
2020-11-15T22:53:33.5251040Z drop cascades to table episode_progresses
2020-11-15T22:53:33.5251450Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:33.5251840Z drop cascades to sequence test_uuids
2020-11-15T22:53:33.5252200Z drop cascades to sequence test_shortids
2020-11-15T22:53:34.2540930Z 2020-11-15T22:53:34+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 09797E4F-CCEE-4A89-9AFE-42B53CE394A5 [Request] POST /subscribe
2020-11-15T22:53:34.3590900Z 2020-11-15T22:53:34+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 09797E4F-CCEE-4A89-9AFE-42B53CE394A5 [Time] 104ms
2020-11-15T22:53:34.3688170Z Test Case '-[PointFreeTests.SubscribeIntegrationTests testHappyPath]' passed (0.878 seconds).
2020-11-15T22:53:34.3689940Z Test Case '-[PointFreeTests.SubscribeIntegrationTests testHappyPath_Referral_Monthly]' started.
2020-11-15T22:53:34.3827770Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:34.3828290Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:34.3829490Z drop cascades to extension uuid-ossp
2020-11-15T22:53:34.3829870Z drop cascades to extension citext
2020-11-15T22:53:34.3830210Z drop cascades to table users
2020-11-15T22:53:34.3830560Z drop cascades to table subscriptions
2020-11-15T22:53:34.3830930Z drop cascades to table team_invites
2020-11-15T22:53:34.3831700Z drop cascades to table email_settings
2020-11-15T22:53:34.3832110Z drop cascades to table episode_credits
2020-11-15T22:53:34.3832490Z drop cascades to table feed_request_events
2020-11-15T22:53:34.3832870Z drop cascades to function update_updated_at()
2020-11-15T22:53:34.3833290Z drop cascades to table enterprise_accounts
2020-11-15T22:53:34.3833690Z drop cascades to table enterprise_emails
2020-11-15T22:53:34.3834090Z drop cascades to table episode_progresses
2020-11-15T22:53:34.3834510Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:34.3834910Z drop cascades to sequence test_uuids
2020-11-15T22:53:34.3835270Z drop cascades to sequence test_shortids
2020-11-15T22:53:35.2454600Z 2020-11-15T22:53:35+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 6F3EE8F5-3A4C-41F5-8F99-5CB263067266 [Request] POST /subscribe
2020-11-15T22:53:35.3358470Z 2020-11-15T22:53:35+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 6F3EE8F5-3A4C-41F5-8F99-5CB263067266 [Time] 90ms
2020-11-15T22:53:35.3440890Z Test Case '-[PointFreeTests.SubscribeIntegrationTests testHappyPath_Referral_Monthly]' passed (0.975 seconds).
2020-11-15T22:53:35.3442760Z Test Case '-[PointFreeTests.SubscribeIntegrationTests testHappyPath_Referral_Yearly]' started.
2020-11-15T22:53:35.3580210Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:35.3580780Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:35.3581960Z drop cascades to extension uuid-ossp
2020-11-15T22:53:35.3582370Z drop cascades to extension citext
2020-11-15T22:53:35.3582700Z drop cascades to table users
2020-11-15T22:53:35.3583050Z drop cascades to table subscriptions
2020-11-15T22:53:35.3583420Z drop cascades to table team_invites
2020-11-15T22:53:35.3583770Z drop cascades to table email_settings
2020-11-15T22:53:35.3584140Z drop cascades to table episode_credits
2020-11-15T22:53:35.3584530Z drop cascades to table feed_request_events
2020-11-15T22:53:35.3584930Z drop cascades to function update_updated_at()
2020-11-15T22:53:35.3585340Z drop cascades to table enterprise_accounts
2020-11-15T22:53:35.3585740Z drop cascades to table enterprise_emails
2020-11-15T22:53:35.3586130Z drop cascades to table episode_progresses
2020-11-15T22:53:35.3586550Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:35.3586950Z drop cascades to sequence test_uuids
2020-11-15T22:53:35.3587320Z drop cascades to sequence test_shortids
2020-11-15T22:53:36.2487010Z 2020-11-15T22:53:36+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift B9A9D54E-3FA3-4E34-BE94-D071A9811A22 [Request] POST /subscribe
2020-11-15T22:53:36.3405960Z 2020-11-15T22:53:36+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift B9A9D54E-3FA3-4E34-BE94-D071A9811A22 [Time] 91ms
2020-11-15T22:53:36.3482140Z Test Case '-[PointFreeTests.SubscribeIntegrationTests testHappyPath_Referral_Yearly]' passed (1.004 seconds).
2020-11-15T22:53:36.3483970Z Test Case '-[PointFreeTests.SubscribeIntegrationTests testHappyPath_RegionalDiscount]' started.
2020-11-15T22:53:36.3619520Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:36.3620040Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:36.3621210Z drop cascades to extension uuid-ossp
2020-11-15T22:53:36.3621600Z drop cascades to extension citext
2020-11-15T22:53:36.3621940Z drop cascades to table users
2020-11-15T22:53:36.3622310Z drop cascades to table subscriptions
2020-11-15T22:53:36.3622680Z drop cascades to table team_invites
2020-11-15T22:53:36.3623040Z drop cascades to table email_settings
2020-11-15T22:53:36.3623410Z drop cascades to table episode_credits
2020-11-15T22:53:36.3623780Z drop cascades to table feed_request_events
2020-11-15T22:53:36.3624620Z drop cascades to function update_updated_at()
2020-11-15T22:53:36.3625070Z drop cascades to table enterprise_accounts
2020-11-15T22:53:36.3625480Z drop cascades to table enterprise_emails
2020-11-15T22:53:36.3625880Z drop cascades to table episode_progresses
2020-11-15T22:53:36.3626300Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:36.3626700Z drop cascades to sequence test_uuids
2020-11-15T22:53:36.3627070Z drop cascades to sequence test_shortids
2020-11-15T22:53:37.1147570Z 2020-11-15T22:53:37+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 E421FF52-0091-459D-B834-AA3CABF93036 [Request] POST /subscribe
2020-11-15T22:53:37.2085990Z 2020-11-15T22:53:37+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift E421FF52-0091-459D-B834-AA3CABF93036 [Time] 93ms
2020-11-15T22:53:37.2183100Z Test Case '-[PointFreeTests.SubscribeIntegrationTests testHappyPath_RegionalDiscount]' passed (0.870 seconds).
2020-11-15T22:53:37.2184920Z Test Case '-[PointFreeTests.SubscribeIntegrationTests testHappyPath_Team]' started.
2020-11-15T22:53:37.2321920Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:37.2322510Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:37.2323690Z drop cascades to extension uuid-ossp
2020-11-15T22:53:37.2324080Z drop cascades to extension citext
2020-11-15T22:53:37.2324400Z drop cascades to table users
2020-11-15T22:53:37.2324750Z drop cascades to table subscriptions
2020-11-15T22:53:37.2325130Z drop cascades to table team_invites
2020-11-15T22:53:37.2325510Z drop cascades to table email_settings
2020-11-15T22:53:37.2325870Z drop cascades to table episode_credits
2020-11-15T22:53:37.2326250Z drop cascades to table feed_request_events
2020-11-15T22:53:37.2326650Z drop cascades to function update_updated_at()
2020-11-15T22:53:37.2327060Z drop cascades to table enterprise_accounts
2020-11-15T22:53:37.2327460Z drop cascades to table enterprise_emails
2020-11-15T22:53:37.2327860Z drop cascades to table episode_progresses
2020-11-15T22:53:37.2328270Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:37.2328670Z drop cascades to sequence test_uuids
2020-11-15T22:53:37.2329040Z drop cascades to sequence test_shortids
2020-11-15T22:53:37.9754260Z 2020-11-15T22:53:37+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 143E3785-8A93-4513-8B2F-CCA4FF41F949 [Request] POST /subscribe
2020-11-15T22:53:38.1424850Z 2020-11-15T22:53:38+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 143E3785-8A93-4513-8B2F-CCA4FF41F949 [Time] 167ms
2020-11-15T22:53:38.1580850Z Test Case '-[PointFreeTests.SubscribeIntegrationTests testHappyPath_Team]' passed (0.940 seconds).
2020-11-15T22:53:38.1582840Z Test Case '-[PointFreeTests.SubscribeIntegrationTests testHappyPath_Team_OwnerIsNotTakingSeat]' started.
2020-11-15T22:53:38.1718910Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:38.1719470Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:38.1720640Z drop cascades to extension uuid-ossp
2020-11-15T22:53:38.1721030Z drop cascades to extension citext
2020-11-15T22:53:38.1721370Z drop cascades to table users
2020-11-15T22:53:38.1721720Z drop cascades to table subscriptions
2020-11-15T22:53:38.1722100Z drop cascades to table team_invites
2020-11-15T22:53:38.1722440Z drop cascades to table email_settings
2020-11-15T22:53:38.1722820Z drop cascades to table episode_credits
2020-11-15T22:53:38.1723220Z drop cascades to table feed_request_events
2020-11-15T22:53:38.1723620Z drop cascades to function update_updated_at()
2020-11-15T22:53:38.1724030Z drop cascades to table enterprise_accounts
2020-11-15T22:53:38.1724430Z drop cascades to table enterprise_emails
2020-11-15T22:53:38.1724830Z drop cascades to table episode_progresses
2020-11-15T22:53:38.1725640Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:38.1726060Z drop cascades to sequence test_uuids
2020-11-15T22:53:38.1726440Z drop cascades to sequence test_shortids
2020-11-15T22:53:39.0016770Z 2020-11-15T22:53:39+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift F19A1686-1D23-4371-B875-D64108ECA364 [Request] POST /subscribe
2020-11-15T22:53:39.1769520Z 2020-11-15T22:53:39+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 F19A1686-1D23-4371-B875-D64108ECA364 [Time] 175ms
2020-11-15T22:53:39.2028310Z Test Case '-[PointFreeTests.SubscribeIntegrationTests testHappyPath_Team_OwnerIsNotTakingSeat]' passed (1.045 seconds).
2020-11-15T22:53:39.2032720Z Test Case '-[PointFreeTests.SubscribeIntegrationTests testHappyPath_Yearly]' started.
2020-11-15T22:53:39.2186870Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:39.2187440Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:39.2188680Z drop cascades to extension uuid-ossp
2020-11-15T22:53:39.2189060Z drop cascades to extension citext
2020-11-15T22:53:39.2189390Z drop cascades to table users
2020-11-15T22:53:39.2189780Z drop cascades to table subscriptions
2020-11-15T22:53:39.2190160Z drop cascades to table team_invites
2020-11-15T22:53:39.2190520Z drop cascades to table email_settings
2020-11-15T22:53:39.2190880Z drop cascades to table episode_credits
2020-11-15T22:53:39.2191260Z drop cascades to table feed_request_events
2020-11-15T22:53:39.2191660Z drop cascades to function update_updated_at()
2020-11-15T22:53:39.2192070Z drop cascades to table enterprise_accounts
2020-11-15T22:53:39.2194200Z drop cascades to table enterprise_emails
2020-11-15T22:53:39.2194610Z drop cascades to table episode_progresses
2020-11-15T22:53:39.2195030Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:39.2195420Z drop cascades to sequence test_uuids
2020-11-15T22:53:39.2195800Z drop cascades to sequence test_shortids
2020-11-15T22:53:39.9891740Z 2020-11-15T22:53:39+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 55786111-4A7F-4ADC-94C5-C2EC2BC605C5 [Request] POST /subscribe
2020-11-15T22:53:40.0830540Z 2020-11-15T22:53:40+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 55786111-4A7F-4ADC-94C5-C2EC2BC605C5 [Time] 93ms
2020-11-15T22:53:40.0925060Z Test Case '-[PointFreeTests.SubscribeIntegrationTests testHappyPath_Yearly]' passed (0.890 seconds).
2020-11-15T22:53:40.0927080Z Test Case '-[PointFreeTests.SubscribeIntegrationTests testRegionalDiscountWithReferral_Monthly]' started.
2020-11-15T22:53:40.1065760Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:40.1066220Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:40.1067470Z drop cascades to extension uuid-ossp
2020-11-15T22:53:40.1067860Z drop cascades to extension citext
2020-11-15T22:53:40.1068200Z drop cascades to table users
2020-11-15T22:53:40.1068550Z drop cascades to table subscriptions
2020-11-15T22:53:40.1068920Z drop cascades to table team_invites
2020-11-15T22:53:40.1069260Z drop cascades to table email_settings
2020-11-15T22:53:40.1069630Z drop cascades to table episode_credits
2020-11-15T22:53:40.1070010Z drop cascades to table feed_request_events
2020-11-15T22:53:40.1070400Z drop cascades to function update_updated_at()
2020-11-15T22:53:40.1070810Z drop cascades to table enterprise_accounts
2020-11-15T22:53:40.1071210Z drop cascades to table enterprise_emails
2020-11-15T22:53:40.1071620Z drop cascades to table episode_progresses
2020-11-15T22:53:40.1072020Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:40.1072420Z drop cascades to sequence test_uuids
2020-11-15T22:53:40.1072790Z drop cascades to sequence test_shortids
2020-11-15T22:53:41.0187000Z 2020-11-15T22:53:41+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 C8F24DDB-D84F-484C-9374-E0C8B6A486A4 [Request] POST /subscribe
2020-11-15T22:53:41.1070310Z 2020-11-15T22:53:41+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 C8F24DDB-D84F-484C-9374-E0C8B6A486A4 [Time] 88ms
2020-11-15T22:53:41.1145680Z Test Case '-[PointFreeTests.SubscribeIntegrationTests testRegionalDiscountWithReferral_Monthly]' passed (1.022 seconds).
2020-11-15T22:53:41.1147910Z Test Case '-[PointFreeTests.SubscribeIntegrationTests testRegionalDiscountWithReferral_Yearly]' started.
2020-11-15T22:53:41.1284410Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:41.1284920Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:41.1286080Z drop cascades to extension uuid-ossp
2020-11-15T22:53:41.1286470Z drop cascades to extension citext
2020-11-15T22:53:41.1286820Z drop cascades to table users
2020-11-15T22:53:41.1287170Z drop cascades to table subscriptions
2020-11-15T22:53:41.1287540Z drop cascades to table team_invites
2020-11-15T22:53:41.1287900Z drop cascades to table email_settings
2020-11-15T22:53:41.1288260Z drop cascades to table episode_credits
2020-11-15T22:53:41.1288640Z drop cascades to table feed_request_events
2020-11-15T22:53:41.1289040Z drop cascades to function update_updated_at()
2020-11-15T22:53:41.1289430Z drop cascades to table enterprise_accounts
2020-11-15T22:53:41.1289830Z drop cascades to table enterprise_emails
2020-11-15T22:53:41.1290230Z drop cascades to table episode_progresses
2020-11-15T22:53:41.1290660Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:41.1291050Z drop cascades to sequence test_uuids
2020-11-15T22:53:41.1291420Z drop cascades to sequence test_shortids
2020-11-15T22:53:42.0465750Z 2020-11-15T22:53:42+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 2B2F972B-28F5-4E53-A62F-93545E240330 [Request] POST /subscribe
2020-11-15T22:53:42.1365750Z 2020-11-15T22:53:42+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 2B2F972B-28F5-4E53-A62F-93545E240330 [Time] 90ms
2020-11-15T22:53:42.1446140Z Test Case '-[PointFreeTests.SubscribeIntegrationTests testRegionalDiscountWithReferral_Yearly]' passed (1.030 seconds).
2020-11-15T22:53:42.1449020Z Test Case '-[PointFreeTests.SubscribeIntegrationTests testSubscribingWithRegionalDiscountAndCoupon]' started.
2020-11-15T22:53:42.1588720Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:42.1589280Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:42.1590440Z drop cascades to extension uuid-ossp
2020-11-15T22:53:42.1590830Z drop cascades to extension citext
2020-11-15T22:53:42.1591170Z drop cascades to table users
2020-11-15T22:53:42.1591520Z drop cascades to table subscriptions
2020-11-15T22:53:42.1591910Z drop cascades to table team_invites
2020-11-15T22:53:42.1592260Z drop cascades to table email_settings
2020-11-15T22:53:42.1592620Z drop cascades to table episode_credits
2020-11-15T22:53:42.1593000Z drop cascades to table feed_request_events
2020-11-15T22:53:42.1593400Z drop cascades to function update_updated_at()
2020-11-15T22:53:42.1593810Z drop cascades to table enterprise_accounts
2020-11-15T22:53:42.1594210Z drop cascades to table enterprise_emails
2020-11-15T22:53:42.1594610Z drop cascades to table episode_progresses
2020-11-15T22:53:42.1595030Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:42.1595430Z drop cascades to sequence test_uuids
2020-11-15T22:53:42.1595790Z drop cascades to sequence test_shortids
2020-11-15T22:53:42.9654840Z 2020-11-15T22:53:42+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 0CFB5272-E8D5-45B7-8A06-7E7F18BF7AF1 [Request] POST /subscribe
2020-11-15T22:53:42.9834140Z 2020-11-15T22:53:42+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 0CFB5272-E8D5-45B7-8A06-7E7F18BF7AF1 [Time] 18ms
2020-11-15T22:53:42.9845710Z Test Case '-[PointFreeTests.SubscribeIntegrationTests testSubscribingWithRegionalDiscountAndCoupon]' passed (0.840 seconds).
2020-11-15T22:53:42.9848490Z Test Case '-[PointFreeTests.SubscribeIntegrationTests testUnhappyPath_RegionalDiscount]' started.
2020-11-15T22:53:43.0000490Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:43.0002680Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:43.0004630Z drop cascades to extension uuid-ossp
2020-11-15T22:53:43.0005020Z drop cascades to extension citext
2020-11-15T22:53:43.0005970Z drop cascades to table users
2020-11-15T22:53:43.0006320Z drop cascades to table subscriptions
2020-11-15T22:53:43.0007160Z drop cascades to table team_invites
2020-11-15T22:53:43.0007550Z drop cascades to table email_settings
2020-11-15T22:53:43.0007920Z drop cascades to table episode_credits
2020-11-15T22:53:43.0008290Z drop cascades to table feed_request_events
2020-11-15T22:53:43.0008690Z drop cascades to function update_updated_at()
2020-11-15T22:53:43.0009790Z drop cascades to table enterprise_accounts
2020-11-15T22:53:43.0010200Z drop cascades to table enterprise_emails
2020-11-15T22:53:43.0010800Z drop cascades to table episode_progresses
2020-11-15T22:53:43.0011800Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:43.0012230Z drop cascades to sequence test_uuids
2020-11-15T22:53:43.0012600Z drop cascades to sequence test_shortids
2020-11-15T22:53:43.7302610Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 1E9216D7-AFA4-446F-8699-1B826514FA74 [Request] POST /subscribe
2020-11-15T22:53:43.7496310Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 1E9216D7-AFA4-446F-8699-1B826514FA74 [Time] 19ms
2020-11-15T22:53:43.7506280Z Test Case '-[PointFreeTests.SubscribeIntegrationTests testUnhappyPath_RegionalDiscount]' passed (0.766 seconds).
2020-11-15T22:53:43.7507840Z Test Suite 'SubscribeIntegrationTests' passed at 2020-11-15 22:53:43.750.
2020-11-15T22:53:43.7508800Z    Executed 13 tests, with 0 failures (0 unexpected) in 11.731 (11.732) seconds
2020-11-15T22:53:43.7509700Z Test Suite 'SubscribeTests' started at 2020-11-15 22:53:43.751
2020-11-15T22:53:43.7510770Z Test Case '-[PointFreeTests.SubscribeTests testCouponFailure_Individual]' started.
2020-11-15T22:53:43.7568460Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 8B122496-CBAA-42A3-ACEB-96E16E9C70ED [Request] POST /subscribe
2020-11-15T22:53:43.7599200Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 8B122496-CBAA-42A3-ACEB-96E16E9C70ED [Time] 3ms
2020-11-15T22:53:43.7610840Z Test Case '-[PointFreeTests.SubscribeTests testCouponFailure_Individual]' passed (0.010 seconds).
2020-11-15T22:53:43.7612580Z Test Case '-[PointFreeTests.SubscribeTests testCreateCustomerFailure]' started.
2020-11-15T22:53:43.7654950Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 37686C54-7537-4941-BF84-68AE1E8427DA [Request] POST /subscribe
2020-11-15T22:53:43.7701690Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 37686C54-7537-4941-BF84-68AE1E8427DA [Time] 4ms
2020-11-15T22:53:43.7711070Z Test Case '-[PointFreeTests.SubscribeTests testCreateCustomerFailure]' passed (0.010 seconds).
2020-11-15T22:53:43.7713880Z Test Case '-[PointFreeTests.SubscribeTests testCreateDatabaseSubscriptionFailure]' started.
2020-11-15T22:53:43.7753880Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 6E637F0B-3E64-40F5-8656-76422B332593 [Request] POST /subscribe
2020-11-15T22:53:43.7801160Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 6E637F0B-3E64-40F5-8656-76422B332593 [Time] 4ms
2020-11-15T22:53:43.7812340Z Test Case '-[PointFreeTests.SubscribeTests testCreateDatabaseSubscriptionFailure]' passed (0.010 seconds).
2020-11-15T22:53:43.7814610Z Test Case '-[PointFreeTests.SubscribeTests testCreateStripeSubscriptionFailure]' started.
2020-11-15T22:53:43.7856210Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 55C2C292-66A6-49E1-B33F-CDEEFC4ED32A [Request] POST /subscribe
2020-11-15T22:53:43.7900850Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 55C2C292-66A6-49E1-B33F-CDEEFC4ED32A [Time] 4ms
2020-11-15T22:53:43.7910990Z Test Case '-[PointFreeTests.SubscribeTests testCreateStripeSubscriptionFailure]' passed (0.010 seconds).
2020-11-15T22:53:43.7912890Z Test Case '-[PointFreeTests.SubscribeTests testCreateStripeSubscriptionFailure_TeamAndMonthly]' started.
2020-11-15T22:53:43.7954510Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 5BDDAC0C-3147-46F6-ADC4-8CF7D17561BC [Request] POST /subscribe
2020-11-15T22:53:43.8000540Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 5BDDAC0C-3147-46F6-ADC4-8CF7D17561BC [Time] 4ms
2020-11-15T22:53:43.8010640Z Test Case '-[PointFreeTests.SubscribeTests testCreateStripeSubscriptionFailure_TeamAndMonthly]' passed (0.010 seconds).
2020-11-15T22:53:43.8012670Z Test Case '-[PointFreeTests.SubscribeTests testCreateStripeSubscriptionFailure_TeamAndMonthly_TooManyEmails]' started.
2020-11-15T22:53:43.8053360Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 9BCDEE22-0A8D-4A03-BE37-A1F67F9EDC3F [Request] POST /subscribe
2020-11-15T22:53:43.8102040Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 9BCDEE22-0A8D-4A03-BE37-A1F67F9EDC3F [Time] 4ms
2020-11-15T22:53:43.8112640Z Test Case '-[PointFreeTests.SubscribeTests testCreateStripeSubscriptionFailure_TeamAndMonthly_TooManyEmails]' passed (0.010 seconds).
2020-11-15T22:53:43.8114650Z Test Case '-[PointFreeTests.SubscribeTests testCurrentSubscribers]' started.
2020-11-15T22:53:43.8154280Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 0CDA09BB-514C-4E17-A1D5-7A91EA20E66E [Request] POST /subscribe
2020-11-15T22:53:43.8171640Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 0CDA09BB-514C-4E17-A1D5-7A91EA20E66E [Time] 1ms
2020-11-15T22:53:43.8180830Z Test Case '-[PointFreeTests.SubscribeTests testCurrentSubscribers]' passed (0.007 seconds).
2020-11-15T22:53:43.8182470Z Test Case '-[PointFreeTests.SubscribeTests testInvalidQuantity]' started.
2020-11-15T22:53:43.8223280Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 7DEE8715-1389-4202-BCF3-3282ABBD824C [Request] POST /subscribe
2020-11-15T22:53:43.8266020Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 7DEE8715-1389-4202-BCF3-3282ABBD824C [Time] 4ms
2020-11-15T22:53:43.8304720Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 14F1C96A-10EA-4605-9D47-044AAC8CBE6D [Request] POST /subscribe
2020-11-15T22:53:43.8344780Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 14F1C96A-10EA-4605-9D47-044AAC8CBE6D [Time] 4ms
2020-11-15T22:53:43.8357250Z Test Case '-[PointFreeTests.SubscribeTests testInvalidQuantity]' passed (0.018 seconds).
2020-11-15T22:53:43.8359170Z Test Case '-[PointFreeTests.SubscribeTests testNotLoggedIn_IndividualMonthly]' started.
2020-11-15T22:53:43.8400770Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 593E5551-164F-4E79-BAC1-851651EF4B1D [Request] POST /subscribe
2020-11-15T22:53:43.8433930Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 593E5551-164F-4E79-BAC1-851651EF4B1D [Time] 3ms
2020-11-15T22:53:43.8444520Z Test Case '-[PointFreeTests.SubscribeTests testNotLoggedIn_IndividualMonthly]' passed (0.009 seconds).
2020-11-15T22:53:43.8446110Z Test Case '-[PointFreeTests.SubscribeTests testNotLoggedIn_IndividualYearly]' started.
2020-11-15T22:53:43.8487370Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 1103C91E-4C51-483D-8D63-C5E4EE14C3D8 [Request] POST /subscribe
2020-11-15T22:53:43.8518140Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 1103C91E-4C51-483D-8D63-C5E4EE14C3D8 [Time] 3ms
2020-11-15T22:53:43.8528310Z Test Case '-[PointFreeTests.SubscribeTests testNotLoggedIn_IndividualYearly]' passed (0.008 seconds).
2020-11-15T22:53:43.8529750Z Test Case '-[PointFreeTests.SubscribeTests testNotLoggedIn_Team]' started.
2020-11-15T22:53:43.8571020Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 9E50F417-9DCA-46DF-82F2-045D6135922D [Request] POST /subscribe
2020-11-15T22:53:43.8604640Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 9E50F417-9DCA-46DF-82F2-045D6135922D [Time] 3ms
2020-11-15T22:53:43.8611890Z Test Case '-[PointFreeTests.SubscribeTests testNotLoggedIn_Team]' passed (0.008 seconds).
2020-11-15T22:53:43.8613280Z Test Case '-[PointFreeTests.SubscribeTests testReferrals_InactiveCode]' started.
2020-11-15T22:53:43.8655460Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 23CDD42D-2BD9-4523-A1A8-B19F615DCAC8 [Request] POST /subscribe
2020-11-15T22:53:43.8703070Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 23CDD42D-2BD9-4523-A1A8-B19F615DCAC8 [Time] 4ms
2020-11-15T22:53:43.8717710Z Test Case '-[PointFreeTests.SubscribeTests testReferrals_InactiveCode]' passed (0.010 seconds).
2020-11-15T22:53:43.8720880Z Test Case '-[PointFreeTests.SubscribeTests testReferrals_InvalidCode]' started.
2020-11-15T22:53:43.8764010Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 7F3E79DD-DEF1-4716-B0DF-7FD2EEF80E80 [Request] POST /subscribe
2020-11-15T22:53:43.8807860Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 7F3E79DD-DEF1-4716-B0DF-7FD2EEF80E80 [Time] 4ms
2020-11-15T22:53:43.8817370Z Test Case '-[PointFreeTests.SubscribeTests testReferrals_InvalidCode]' passed (0.010 seconds).
2020-11-15T22:53:43.8819070Z Test Case '-[PointFreeTests.SubscribeTests testReferrals_InvalidLane]' started.
2020-11-15T22:53:43.8860830Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 B942DDB7-EE27-4742-A84A-48861E39A54B [Request] POST /subscribe
2020-11-15T22:53:43.8900370Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift B942DDB7-EE27-4742-A84A-48861E39A54B [Time] 4ms
2020-11-15T22:53:43.8910300Z Test Case '-[PointFreeTests.SubscribeTests testReferrals_InvalidLane]' passed (0.009 seconds).
2020-11-15T22:53:43.8911720Z Test Case '-[PointFreeTests.SubscribeTests testReferrals_PreviouslyReferred]' started.
2020-11-15T22:53:43.8953820Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift F02CC0E7-AC17-4EB9-AAE4-3DFFEB383582 [Request] POST /subscribe
2020-11-15T22:53:43.8995080Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 F02CC0E7-AC17-4EB9-AAE4-3DFFEB383582 [Time] 4ms
2020-11-15T22:53:43.9005180Z Test Case '-[PointFreeTests.SubscribeTests testReferrals_PreviouslyReferred]' passed (0.009 seconds).
2020-11-15T22:53:43.9006380Z Test Suite 'SubscribeTests' passed at 2020-11-15 22:53:43.900.
2020-11-15T22:53:43.9006860Z    Executed 15 tests, with 0 failures (0 unexpected) in 0.149 (0.150) seconds
2020-11-15T22:53:43.9007850Z Test Suite 'SubscriptionConfirmationTests' started at 2020-11-15 22:53:43.900
2020-11-15T22:53:43.9009270Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testPersonal_LoggedIn]' started.
2020-11-15T22:53:43.9045050Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 10D34D1F-F004-423D-B18B-C684B2F66A4E [Request] GET /subscribe/personal
2020-11-15T22:53:43.9515460Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 10D34D1F-F004-423D-B18B-C684B2F66A4E [Time] 46ms
2020-11-15T22:53:43.9614640Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testPersonal_LoggedIn]' passed (0.052 seconds).
2020-11-15T22:53:43.9617050Z 2020-11-15T22:53:43+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 FE7EE7CA-F97C-43C9-97FD-48CF28CCF801 [Request] GET /subscribe/personal
2020-11-15T22:53:43.9716540Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testPersonal_LoggedIn_ActiveSubscriber]' started.
2020-11-15T22:53:44.0044320Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 FE7EE7CA-F97C-43C9-97FD-48CF28CCF801 [Time] 47ms
2020-11-15T22:53:44.0055110Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testPersonal_LoggedIn_ActiveSubscriber]' passed (0.053 seconds).
2020-11-15T22:53:44.0059940Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testPersonal_LoggedIn_PreviouslyReferred]' started.
2020-11-15T22:53:44.0103200Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 02EAD8A7-0F12-4EE2-A310-0D72EDAEACB5 [Request] GET /subscribe/personal
2020-11-15T22:53:44.0145140Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 02EAD8A7-0F12-4EE2-A310-0D72EDAEACB5 [Time] 4ms
2020-11-15T22:53:44.0154380Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testPersonal_LoggedIn_PreviouslyReferred]' passed (0.010 seconds).
2020-11-15T22:53:44.0157100Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testPersonal_LoggedIn_SwitchToMonthly]' started.
2020-11-15T22:53:44.0201700Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift F3F9AD91-93B2-48BA-A12A-71F305E18B74 [Request] GET /subscribe/personal
2020-11-15T22:53:44.0215800Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testPersonal_LoggedIn_SwitchToMonthly]' passed (0.006 seconds).
2020-11-15T22:53:44.0222100Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testPersonal_LoggedIn_SwitchToMonthly_RegionalDiscount]' started.
2020-11-15T22:53:44.0273650Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testPersonal_LoggedIn_SwitchToMonthly_RegionalDiscount]' passed (0.006 seconds).
2020-11-15T22:53:44.0277500Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift ECEA87E3-7D4D-4C5F-B4E6-2B69916E3DAB [Request] GET /subscribe/personal
2020-11-15T22:53:44.0330330Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testPersonal_LoggedIn_WithDiscount]' started.
2020-11-15T22:53:44.0355090Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 DE108BD7-C683-4FE2-887C-77F2A8E6B285 [Request] GET /discounts/dead-beef
2020-11-15T22:53:44.0741340Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift DE108BD7-C683-4FE2-887C-77F2A8E6B285 [Time] 44ms
2020-11-15T22:53:44.0751640Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testPersonal_LoggedIn_WithDiscount]' passed (0.048 seconds).
2020-11-15T22:53:44.0801730Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testPersonal_LoggedOut]' started.
2020-11-15T22:53:44.0803970Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 6D74D6BB-32A0-4577-AF64-610E841C15DA [Request] GET /subscribe/personal
2020-11-15T22:53:44.1370960Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 6D74D6BB-32A0-4577-AF64-610E841C15DA [Time] 56ms
2020-11-15T22:53:44.1379600Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testPersonal_LoggedOut]' passed (0.063 seconds).
2020-11-15T22:53:44.1382130Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testPersonal_LoggedOut_InactiveReferralCode]' started.
2020-11-15T22:53:44.1421210Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 502E8F26-1B69-4AC7-802A-6160D5E500B5 [Request] GET /subscribe/personal
2020-11-15T22:53:44.1464990Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 502E8F26-1B69-4AC7-802A-6160D5E500B5 [Time] 4ms
2020-11-15T22:53:44.1473420Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testPersonal_LoggedOut_InactiveReferralCode]' passed (0.009 seconds).
2020-11-15T22:53:44.1475820Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testPersonal_LoggedOut_InvalidReferralCode]' started.
2020-11-15T22:53:44.1515100Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 82033E28-5B21-4AA0-A290-43FEAD3D5DDF [Request] GET /subscribe/personal
2020-11-15T22:53:44.1558130Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 82033E28-5B21-4AA0-A290-43FEAD3D5DDF [Time] 4ms
2020-11-15T22:53:44.1568230Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testPersonal_LoggedOut_InvalidReferralCode]' passed (0.009 seconds).
2020-11-15T22:53:44.1571070Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testPersonal_LoggedOut_InvalidReferralLane]' started.
2020-11-15T22:53:44.1614870Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 A52B537B-95E7-43B3-B57E-477BCFC1326E [Request] GET /subscribe/team
2020-11-15T22:53:44.1658230Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift A52B537B-95E7-43B3-B57E-477BCFC1326E [Time] 4ms
2020-11-15T22:53:44.1664420Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testPersonal_LoggedOut_InvalidReferralLane]' passed (0.010 seconds).
2020-11-15T22:53:44.1705020Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testPersonal_LoggedOut_ReferralCode]' started.
2020-11-15T22:53:44.1707530Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 A3F0B1B0-7860-4379-B555-5FC4BDC6EEF4 [Request] GET /subscribe/personal
2020-11-15T22:53:44.2345130Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 A3F0B1B0-7860-4379-B555-5FC4BDC6EEF4 [Time] 63ms
2020-11-15T22:53:44.2363570Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testPersonal_LoggedOut_ReferralCode]' passed (0.070 seconds).
2020-11-15T22:53:44.2370120Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testPersonal_ReferralCodeAndRegionalDiscount]' started.
2020-11-15T22:53:44.2414710Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift E93248F0-3C9F-4DCF-A925-7522E15454B7 [Request] GET /subscribe/personal
2020-11-15T22:53:44.2916980Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 E93248F0-3C9F-4DCF-A925-7522E15454B7 [Time] 50ms
2020-11-15T22:53:44.2932200Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testPersonal_ReferralCodeAndRegionalDiscount]' passed (0.057 seconds).
2020-11-15T22:53:44.2934280Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testTeam_LoggedIn]' started.
2020-11-15T22:53:44.2988500Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 AE579AFD-CFB7-4AF2-A05E-86DD2D2C8A01 [Request] GET /subscribe/team
2020-11-15T22:53:44.3562580Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 AE579AFD-CFB7-4AF2-A05E-86DD2D2C8A01 [Time] 57ms
2020-11-15T22:53:44.3575010Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testTeam_LoggedIn]' passed (0.064 seconds).
2020-11-15T22:53:44.3580820Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testTeam_LoggedIn_AddTeamMember]' started.
2020-11-15T22:53:44.3622020Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 8FAC8300-7FD2-4FCC-AFE8-C3FE136193EC [Request] GET /subscribe/team
2020-11-15T22:53:44.3635350Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testTeam_LoggedIn_AddTeamMember]' passed (0.006 seconds).
2020-11-15T22:53:44.3638550Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testTeam_LoggedIn_RemoveOwnerFromTeam]' started.
2020-11-15T22:53:44.3676530Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift B982D6C6-08CE-4C7C-B53E-F6E846FD409A [Request] GET /subscribe/team
2020-11-15T22:53:44.3694260Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testTeam_LoggedIn_RemoveOwnerFromTeam]' passed (0.006 seconds).
2020-11-15T22:53:44.3696830Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testTeam_LoggedIn_SwitchToMonthly]' started.
2020-11-15T22:53:44.3733810Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 AB88C535-FD7E-4CE2-8970-8FC23B4EBB9E [Request] GET /subscribe/team
2020-11-15T22:53:44.3746290Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testTeam_LoggedIn_SwitchToMonthly]' passed (0.005 seconds).
2020-11-15T22:53:44.3748340Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testTeam_LoggedIn_WithDefaults]' started.
2020-11-15T22:53:44.3791670Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift B42A61D6-7FE7-4445-BE21-28B958BCD562 [Request] GET /subscribe/team
2020-11-15T22:53:44.4266720Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift B42A61D6-7FE7-4445-BE21-28B958BCD562 [Time] 47ms
2020-11-15T22:53:44.4279050Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testTeam_LoggedIn_WithDefaults]' passed (0.053 seconds).
2020-11-15T22:53:44.4281320Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testTeam_LoggedIn_WithDefaults_OwnerIsNotTakingSeat]' started.
2020-11-15T22:53:44.4325090Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift AED2E1AA-F133-4CB6-BF6A-6E2860E9501B [Request] GET /subscribe/team
2020-11-15T22:53:44.4834980Z 2020-11-15T22:53:44+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift AED2E1AA-F133-4CB6-BF6A-6E2860E9501B [Time] 50ms
2020-11-15T22:53:44.4849170Z Test Case '-[PointFreeTests.SubscriptionConfirmationTests testTeam_LoggedIn_WithDefaults_OwnerIsNotTakingSeat]' passed (0.057 seconds).
2020-11-15T22:53:44.4850970Z Test Suite 'SubscriptionConfirmationTests' passed at 2020-11-15 22:53:44.485.
2020-11-15T22:53:44.4851600Z    Executed 18 tests, with 0 failures (0 unexpected) in 0.583 (0.584) seconds
2020-11-15T22:53:44.4852910Z Test Suite 'TeamEmailsTests' started at 2020-11-15 22:53:44.485
2020-11-15T22:53:44.4854280Z Test Case '-[PointFreeTests.TeamEmailsTests testTeammateRemovedEmailView]' started.
2020-11-15T22:53:44.5329110Z Test Case '-[PointFreeTests.TeamEmailsTests testTeammateRemovedEmailView]' passed (0.048 seconds).
2020-11-15T22:53:44.5331020Z Test Case '-[PointFreeTests.TeamEmailsTests testYouHaveBeenRemovedEmailView]' started.
2020-11-15T22:53:44.5849290Z Test Case '-[PointFreeTests.TeamEmailsTests testYouHaveBeenRemovedEmailView]' passed (0.052 seconds).
2020-11-15T22:53:44.5851000Z Test Suite 'TeamEmailsTests' passed at 2020-11-15 22:53:44.585.
2020-11-15T22:53:44.5851580Z    Executed 2 tests, with 0 failures (0 unexpected) in 0.100 (0.100) seconds
2020-11-15T22:53:44.5853090Z Test Suite 'UpdateProfileIntegrationTests' started at 2020-11-15 22:53:44.585
2020-11-15T22:53:44.5862570Z Test Case '-[PointFreeTests.UpdateProfileIntegrationTests testUpdateEmailSettings]' started.
2020-11-15T22:53:44.6019090Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:44.6019660Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:44.6020810Z drop cascades to extension uuid-ossp
2020-11-15T22:53:44.6021190Z drop cascades to extension citext
2020-11-15T22:53:44.6021530Z drop cascades to table users
2020-11-15T22:53:44.6021870Z drop cascades to table subscriptions
2020-11-15T22:53:44.6022240Z drop cascades to table team_invites
2020-11-15T22:53:44.6022600Z drop cascades to table email_settings
2020-11-15T22:53:44.6022970Z drop cascades to table episode_credits
2020-11-15T22:53:44.6023340Z drop cascades to table feed_request_events
2020-11-15T22:53:44.6023740Z drop cascades to function update_updated_at()
2020-11-15T22:53:44.6024410Z drop cascades to table enterprise_accounts
2020-11-15T22:53:44.6024810Z drop cascades to table enterprise_emails
2020-11-15T22:53:44.6025200Z drop cascades to table episode_progresses
2020-11-15T22:53:44.6025620Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:44.6026020Z drop cascades to sequence test_uuids
2020-11-15T22:53:44.6026390Z drop cascades to sequence test_shortids
2020-11-15T22:53:45.5556670Z 2020-11-15T22:53:45+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 22D702E1-E757-4D27-8A09-A910E50FB60C [Request] POST /account
2020-11-15T22:53:45.6014990Z 2020-11-15T22:53:45+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 22D702E1-E757-4D27-8A09-A910E50FB60C [Time] 45ms
2020-11-15T22:53:45.6096480Z Test Case '-[PointFreeTests.UpdateProfileIntegrationTests testUpdateEmailSettings]' passed (1.025 seconds).
2020-11-15T22:53:45.6098580Z Test Case '-[PointFreeTests.UpdateProfileIntegrationTests testUpdateNameAndEmail]' started.
2020-11-15T22:53:45.6236010Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:45.6236500Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:45.6239180Z drop cascades to extension uuid-ossp
2020-11-15T22:53:45.6239730Z drop cascades to extension citext
2020-11-15T22:53:45.6240080Z drop cascades to table users
2020-11-15T22:53:45.6240440Z drop cascades to table subscriptions
2020-11-15T22:53:45.6240810Z drop cascades to table team_invites
2020-11-15T22:53:45.6241170Z drop cascades to table email_settings
2020-11-15T22:53:45.6241530Z drop cascades to table episode_credits
2020-11-15T22:53:45.6241910Z drop cascades to table feed_request_events
2020-11-15T22:53:45.6242300Z drop cascades to function update_updated_at()
2020-11-15T22:53:45.6242700Z drop cascades to table enterprise_accounts
2020-11-15T22:53:45.6243120Z drop cascades to table enterprise_emails
2020-11-15T22:53:45.6243510Z drop cascades to table episode_progresses
2020-11-15T22:53:45.6243930Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:45.6244320Z drop cascades to sequence test_uuids
2020-11-15T22:53:45.6244690Z drop cascades to sequence test_shortids
2020-11-15T22:53:46.5735830Z 2020-11-15T22:53:46+0000 info co.pointfree.PointFreeTestSupport : file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift line=15 C060C0F2-D0C6-4D5F-8924-8EDDA278B798 [Request] POST /account
2020-11-15T22:53:46.6561950Z 2020-11-15T22:53:46+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift C060C0F2-D0C6-4D5F-8924-8EDDA278B798 [Time] 82ms
2020-11-15T22:53:46.6662220Z Test Case '-[PointFreeTests.UpdateProfileIntegrationTests testUpdateNameAndEmail]' passed (1.057 seconds).
2020-11-15T22:53:46.6663880Z Test Suite 'UpdateProfileIntegrationTests' passed at 2020-11-15 22:53:46.666.
2020-11-15T22:53:46.6664550Z    Executed 2 tests, with 0 failures (0 unexpected) in 2.081 (2.081) seconds
2020-11-15T22:53:46.6665400Z Test Suite 'UpdateProfileTests' started at 2020-11-15 22:53:46.666
2020-11-15T22:53:46.6666610Z Test Case '-[PointFreeTests.UpdateProfileTests testUpdateExtraInvoiceInfo]' started.
2020-11-15T22:53:46.6690800Z 2020-11-15T22:53:46+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 55A41E0F-0E36-4CE7-A952-6FB8EDEDDC4E [Request] POST /account
2020-11-15T22:53:46.7157580Z 2020-11-15T22:53:46+0000 info co.pointfree.PointFreeTestSupport : line=15 file=/Users/runner/work/pointfreeco/pointfreeco/Sources/PointFree/SiteMiddleware.swift 55A41E0F-0E36-4CE7-A952-6FB8EDEDDC4E [Time] 46ms
2020-11-15T22:53:46.7167210Z Test Case '-[PointFreeTests.UpdateProfileTests testUpdateExtraInvoiceInfo]' passed (0.050 seconds).
2020-11-15T22:53:46.7168520Z Test Suite 'UpdateProfileTests' passed at 2020-11-15 22:53:46.717.
2020-11-15T22:53:46.7169480Z    Executed 1 test, with 0 failures (0 unexpected) in 0.050 (0.051) seconds
2020-11-15T22:53:46.7170510Z Test Suite 'WelcomeEmailIntegrationTests' started at 2020-11-15 22:53:46.717
2020-11-15T22:53:46.7172030Z Test Case '-[PointFreeTests.WelcomeEmailIntegrationTests testIncrementEpisodeCredits]' started.
2020-11-15T22:53:46.7309860Z NOTICE:  drop cascades to 16 other objects
2020-11-15T22:53:46.7310400Z DETAIL:  drop cascades to extension pgcrypto
2020-11-15T22:53:46.7311540Z drop cascades to extension uuid-ossp
2020-11-15T22:53:46.7311920Z drop cascades to extension citext
2020-11-15T22:53:46.7312260Z drop cascades to table users
2020-11-15T22:53:46.7312610Z drop cascades to table subscriptions
2020-11-15T22:53:46.7312980Z drop cascades to table team_invites
2020-11-15T22:53:46.7313340Z drop cascades to table email_settings
2020-11-15T22:53:46.7313700Z drop cascades to table episode_credits
2020-11-15T22:53:46.7314070Z drop cascades to table feed_request_events
2020-11-15T22:53:46.7314490Z drop cascades to function update_updated_at()
2020-11-15T22:53:46.7314900Z drop cascades to table enterprise_accounts
2020-11-15T22:53:46.7315300Z drop cascades to table enterprise_emails
2020-11-15T22:53:46.7315690Z drop cascades to table episode_progresses
2020-11-15T22:53:46.7316120Z drop cascades to function gen_shortid(text,text)
2020-11-15T22:53:46.7316510Z drop cascades to sequence test_uuids
2020-11-15T22:53:46.7316870Z drop cascades to sequence test_shortids
2020-11-15T22:53:47.6859540Z Test Case '-[PointFreeTests.WelcomeEmailIntegrationTests testIncrementEpisodeCredits]' passed (0.969 seconds).
2020-11-15T22:53:47.6861270Z Test Suite 'WelcomeEmailIntegrationTests' passed at 2020-11-15 22:53:47.686.
2020-11-15T22:53:47.6861890Z    Executed 1 test, with 0 failures (0 unexpected) in 0.969 (0.969) seconds
2020-11-15T22:53:47.6862740Z Test Suite 'WelcomeEmailTests' started at 2020-11-15 22:53:47.686
2020-11-15T22:53:47.6863820Z Test Case '-[PointFreeTests.WelcomeEmailTests testEpisodeEmails]' started.
2020-11-15T22:53:48.3599420Z Test Case '-[PointFreeTests.WelcomeEmailTests testEpisodeEmails]' passed (0.674 seconds).
2020-11-15T22:53:48.3602680Z Test Case '-[PointFreeTests.WelcomeEmailTests testWelcomeEmail1]' started.
2020-11-15T22:53:48.4167150Z Test Case '-[PointFreeTests.WelcomeEmailTests testWelcomeEmail1]' passed (0.057 seconds).
2020-11-15T22:53:48.4168960Z Test Case '-[PointFreeTests.WelcomeEmailTests testWelcomeEmail2]' started.
2020-11-15T22:53:48.4945270Z Test Case '-[PointFreeTests.WelcomeEmailTests testWelcomeEmail2]' passed (0.078 seconds).
2020-11-15T22:53:48.4964750Z Test Case '-[PointFreeTests.WelcomeEmailTests testWelcomeEmail3]' started.
2020-11-15T22:53:48.5503930Z Test Case '-[PointFreeTests.WelcomeEmailTests testWelcomeEmail3]' passed (0.056 seconds).
2020-11-15T22:53:48.5505610Z Test Suite 'WelcomeEmailTests' passed at 2020-11-15 22:53:48.550.
2020-11-15T22:53:48.5514520Z 📧: Sending 2 welcome emails...
2020-11-15T22:53:48.5515520Z    Executed 4 tests, with 0 failures (0 unexpected) in 0.864 (0.864) seconds
2020-11-15T22:53:48.5516900Z Test Suite 'PointFreePackageTests.xctest' passed at 2020-11-15 22:53:48.550.
2020-11-15T22:53:48.5538410Z    Executed 283 tests, with 0 failures (0 unexpected) in 55.343 (55.367) seconds
2020-11-15T22:53:48.5545240Z Test Suite 'All tests' passed at 2020-11-15 22:53:48.551.
2020-11-15T22:53:48.5546060Z    Executed 283 tests, with 0 failures (0 unexpected) in 55.343 (55.368) seconds
2020-11-15T22:53:48.5708200Z Post job cleanup.
2020-11-15T22:53:48.7105880Z [command]/usr/local/bin/git version
2020-11-15T22:53:48.7181610Z git version 2.29.2
2020-11-15T22:53:48.7233080Z [command]/usr/local/bin/git config --local --name-only --get-regexp core\.sshCommand
2020-11-15T22:53:48.7311910Z [command]/usr/local/bin/git submodule foreach --recursive git config --local --name-only --get-regexp 'core\.sshCommand' && git config --local --unset-all 'core.sshCommand' || :
2020-11-15T22:53:48.8338760Z [command]/usr/local/bin/git config --local --name-only --get-regexp http\.https\:\/\/github\.com\/\.extraheader
2020-11-15T22:53:48.8408790Z http.https://github.com/.extraheader
2020-11-15T22:53:48.8424450Z [command]/usr/local/bin/git config --local --unset-all http.https://github.com/.extraheader
2020-11-15T22:53:48.8506730Z [command]/usr/local/bin/git submodule foreach --recursive git config --local --name-only --get-regexp 'http\.https\:\/\/github\.com\/\.extraheader' && git config --local --unset-all 'http.https://github.com/.extraheader' || :
2020-11-15T22:53:48.9570880Z Cleaning up orphan processes

"""#
