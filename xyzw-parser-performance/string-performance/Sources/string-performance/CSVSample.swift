let csvSample = #"""
1,"Eldon Base for stackable storage shelf, platinum",Muhammed MacIntyre,3,-213.25,38.94,35,Nunavut,Storage & Organization,0.8
2,"1.7 Cubic Foot Compact Cube Office Refrigerators",Barry French,293,457.81,208.16,68.02,Nunavut,Appliances,0.58
3,"Cardinal Slant-D® Ring Binder, Heavy Gauge Vinyl",Barry French,293,46.71,8.69,2.99,Nunavut,Binders and Binder Accessories,0.39
4,R380,Clay Rozendal,483,1198.97,195.99,3.99,Nunavut,Telephones and Communication,0.58
5,Holmes HEPA Air Purifier,Carlos Soltero,515,30.94,21.78,5.94,Nunavut,Appliances,0.5
6,G.E. Longer-Life Indoor Recessed Floodlight Bulbs,Carlos Soltero,515,4.43,6.64,4.95,Nunavut,Office Furnishings,0.37
7,"Angle-D Binders with Locking Rings, Label Holders",Carl Jackson,613,-54.04,7.3,7.72,Nunavut,Binders and Binder Accessories,0.38
8,"SAFCO Mobile Desk Side File, Wire Frame",Carl Jackson,613,127.70,42.76,6.22,Nunavut,Storage & Organization,
9,"SAFCO Commercial Wire Shelving, Black",Monica Federle,643,-695.26,138.14,35,Nunavut,Storage & Organization,
10,Xerox 198,Dorothy Badders,678,-226.36,4.98,8.33,Nunavut,Paper,0.38
11,Xerox 1980,Neola Schneider,807,-166.85,4.28,6.18,Nunavut,Paper,0.4
12,Advantus Map Pennant Flags and Round Head Tacks,Neola Schneider,807,-14.33,3.95,2,Nunavut,Rubber Bands,0.53
13,Holmes HEPA Air Purifier,Carlos Daly,868,134.72,21.78,5.94,Nunavut,Appliances,0.5
14,"DS/HD IBM Formatted Diskettes, 200/Pack - Staples",Carlos Daly,868,114.46,47.98,3.61,Nunavut,Computer Peripherals,0.71
15,"Wilson Jones 1 Hanging DublLock® Ring Binders",Claudia Miner,933,-4.72,5.28,2.99,Nunavut,Binders and Binder Accessories,0.37
16,Ultra Commercial Grade Dual Valve Door Closer,Neola Schneider,995,782.91,39.89,3.04,Nunavut,Office Furnishings,0.53
17,"#10-4 1/8 x 9 1/2 Premium Diagonal Seam Envelopes",Allen Rosenblatt,998,93.80,15.74,1.39,Nunavut,Envelopes,0.4
18,Hon 4-Shelf Metal Bookcases,Sylvia Foulston,1154,440.72,100.98,26.22,Nunavut,Bookcases,0.6
19,"Lesro Sheffield Collection Coffee Table, End Table, Center Table, Corner Table",Sylvia Foulston,1154,-481.04,71.37,69,Nunavut,Tables,0.68
20,g520,Jim Radford,1344,-11.68,65.99,5.26,Nunavut,Telephones and Communication,0.59
21,LX 788,Jim Radford,1344,313.58,155.99,8.99,Nunavut,Telephones and Communication,0.58
22,Avery 52,Carlos Soltero,1412,26.92,3.69,0.5,Nunavut,Labels,0.38
23,Plymouth Boxed Rubber Bands by Plymouth,Carlos Soltero,1412,-5.77,4.71,0.7,Nunavut,Rubber Bands,0.8
24,"GBC Pre-Punched Binding Paper, Plastic, White, 8-1/2 x 11",Carl Ludwig,1539,-172.88,15.99,13.18,Nunavut,Binders and Binder Accessories,0.37
25,"Maxell 3.5 DS/HD IBM-Formatted Diskettes, 10/Pack",Carl Ludwig,1539,-144.55,4.89,4.93,Nunavut,Computer Peripherals,0.66
26,Newell 335,Don Miller,1540,5.76,2.88,0.7,Nunavut,Pens & Art Supplies,0.56
27,SANFORD Liquid Accent™ Tank-Style Highlighters,Annie Cyprus,1702,4.90,2.84,0.93,Nunavut,Pens & Art Supplies,0.54
28,Canon PC940 Copier,Carl Ludwig,1761,-547.61,449.99,49,Nunavut,Copiers and Fax,0.38
29,"Tenex Personal Project File with Scoop Front Design, Black",Carlos Soltero,1792,-5.45,13.48,4.51,Nunavut,Storage & Organization,0.59
30,Col-Erase® Pencils with Erasers,Grant Carroll,2275,41.67,6.08,1.17,Nunavut,Pens & Art Supplies,0.56
31,"Imation 3.5 DS/HD IBM Formatted Diskettes, 10/Pack",Don Miller,2277,-46.03,5.98,4.38,Nunavut,Computer Peripherals,0.75
32,"White Dual Perf Computer Printout Paper, 2700 Sheets, 1 Part, Heavyweight, 20 lbs., 14 7/8 x 11",Don Miller,2277,33.67,40.99,19.99,Nunavut,Paper,0.36
33,Self-Adhesive Address Labels for Typewriters by Universal,Alan Barnes,2532,140.01,7.31,0.49,Nunavut,Labels,0.38
34,Accessory37,Alan Barnes,2532,-78.96,20.99,2.5,Nunavut,Telephones and Communication,0.81
35,Fuji 5.2GB DVD-RAM,Jack Garza,2631,252.66,40.96,1.99,Nunavut,Computer Peripherals,0.55
36,Bevis Steel Folding Chairs,Julia West,2757,-1766.01,95.95,74.35,Nunavut,Chairs & Chairmats,0.57
37,Avery Binder Labels,Eugene Barchas,2791,-236.27,3.89,7.01,Nunavut,Binders and Binder Accessories,0.37
38,Hon Every-Day® Chair Series Swivel Task Chairs,Eugene Barchas,2791,80.44,120.98,30,Nunavut,Chairs & Chairmats,0.64
39,"IBM Multi-Purpose Copy Paper, 8 1/2 x 11, Case",Eugene Barchas,2791,118.94,30.98,5.76,Nunavut,Paper,0.4
40,Global Troy™ Executive Leather Low-Back Tilter,Edward Hooks,2976,3424.22,500.98,26,Nunavut,Chairs & Chairmats,0.6
41,XtraLife® ClearVue™ Slant-D® Ring Binders by Cardinal,Brad Eason,3232,-11.83,7.84,4.71,Nunavut,Binders and Binder Accessories,0.35
42,Computer Printout Paper with Letter-Trim Perforations,Nicole Hansen,3524,52.35,18.97,9.03,Nunavut,Paper,0.37
43,6160,Dorothy Wardle,3908,-180.20,115.99,2.5,Nunavut,Telephones and Communication,0.57
44,Avery 49,Aaron Bergman,4132,1.32,2.88,0.5,Nunavut,Labels,0.36
45,Hoover Portapower™ Portable Vacuum,Jim Radford,4612,-375.64,4.48,49,Nunavut,Appliances,0.6
46,Timeport L7089,Annie Cyprus,4676,-104.25,125.99,7.69,Nunavut,Telephones and Communication,0.58
47,Avery 510,Annie Cyprus,4676,85.96,3.75,0.5,Nunavut,Labels,0.37
48,Xerox 1881,Annie Cyprus,4676,-8.38,12.28,6.47,Nunavut,Paper,0.38
49,LX 788,Annie Cyprus,4676,1115.69,155.99,8.99,Nunavut,Telephones and Communication,0.58
50,"Cardinal Slant-D® Ring Binder, Heavy Gauge Vinyl",Annie Cyprus,5284,-3.05,8.69,2.99,Nunavut,Binders and Binder Accessories,0.39
51,"Memorex 4.7GB DVD-RAM, 3/Pack",Clay Rozendal,5316,514.07,31.78,1.99,Nunavut,Computer Peripherals,0.42
52,Unpadded Memo Slips,Don Jones,5409,-7.04,3.98,2.97,Nunavut,Paper,0.35
53,"Adams Telephone Message Book W/Dividers/Space For Phone Numbers, 5 1/4X8 1/2, 300/Messages",Beth Thompson,5506,4.41,5.88,3.04,Nunavut,Paper,0.36
54,"Eldon Expressions™ Desk Accessory, Wood Pencil Holder, Oak",Frank Price,5569,-0.06,9.65,6.22,Nunavut,Office Furnishings,0.55
55,Bell Sonecor JB700 Caller ID,Michelle Lonsdale,5607,-50.33,7.99,5.03,Nunavut,Telephones and Communication,0.6
56,Avery Arch Ring Binders,Ann Chong,5894,87.68,58.1,1.49,Nunavut,Binders and Binder Accessories,0.38
57,APC 7 Outlet Network SurgeArrest Surge Protector,Ann Chong,5894,-68.22,80.48,4.5,Nunavut,Appliances,0.55
58,"Deflect-o RollaMat Studded, Beveled Mat for Medium Pile Carpeting",Joy Bell,5925,-354.90,92.23,39.61,Nunavut,Office Furnishings,0.67
59,Accessory4,Joy Bell,5925,-267.01,85.99,0.99,Nunavut,Telephones and Communication,0.85
60,Personal Creations™ Ink Jet Cards and Labels,Skye Norling,6016,3.63,11.48,5.43,Nunavut,Paper,0.36
61,High Speed Automatic Electric Letter Opener,Barry Weirich,6116,-1759.58,1637.53,24.49,Nunavut,"Scissors, Rulers and Trimmers",0.81
62,Xerox 1966,Grant Carroll,6182,-116.79,6.48,6.65,Nunavut,Paper,0.36
63,Xerox 213,Grant Carroll,6182,-67.28,6.48,7.86,Nunavut,Paper,0.37
64,"Boston Electric Pencil Sharpener, Model 1818, Charcoal Black",Adrian Hane,6535,-19.33,28.15,8.99,Nunavut,Pens & Art Supplies,0.57
65,Hammermill CopyPlus Copy Paper (20Lb. and 84 Bright),Skye Norling,6884,-61.21,4.98,4.75,Nunavut,Paper,0.36
66,"Telephone Message Books with Fax/Mobile Section, 5 1/2 x 3 3/16",Skye Norling,6884,119.09,6.35,1.02,Nunavut,Paper,0.39
67,Crate-A-Files™,Andrew Gjertsen,6916,-141.27,10.9,7.46,Nunavut,Storage & Organization,0.59
68,"Angle-D Binders with Locking Rings, Label Holders",Ralph Knight,6980,-77.28,7.3,7.72,Nunavut,Binders and Binder Accessories,0.38
69,"80 Minute CD-R Spindle, 100/Pack - Staples",Dorothy Wardle,6982,407.44,39.48,1.99,Nunavut,Computer Peripherals,0.54
70,"Bush Westfield Collection Bookcases, Dark Cherry Finish, Fully Assembled",Dorothy Wardle,6982,-338.27,100.98,57.38,Nunavut,Bookcases,0.78
71,12-1/2 Diameter Round Wall Clock,Dorothy Wardle,6982,52.56,19.98,10.49,Nunavut,Office Furnishings,0.49
72,SAFCO Arco Folding Chair,Grant Carroll,7110,1902.24,276.2,24.49,Nunavut,Chairs & Chairmats,
73,"#10 White Business Envelopes,4 1/8 x 9 1/2",Barry Weirich,7430,353.20,15.67,1.39,Nunavut,Envelopes,0.38
74,3M Office Air Cleaner,Beth Paige,7906,271.78,25.98,5.37,Nunavut,Appliances,0.5
75,"Global Leather and Oak Executive Chair, Black",Sylvia Foulston,8391,-268.36,300.98,64.73,Nunavut,Chairs & Chairmats,0.56
76,Xerox 1936,Nicole Hansen,8419,70.39,19.98,5.97,Nunavut,Paper,0.38
77,Xerox 214,Nicole Hansen,8419,-86.62,6.48,7.03,Nunavut,Paper,0.37
78,Carina Double Wide Media Storage Towers in Natural & Black,Nicole Hansen,8833,-846.73,80.98,35,Nunavut,Storage & Organization,0.81
79,Staples® General Use 3-Ring Binders,Beth Paige,8995,8.05,1.88,1.49,Nunavut,Binders and Binder Accessories,0.37
80,Xerox 1904,Beth Paige,8995,-78.02,6.48,5.86,Northwest Territories,Paper,0.36
81,Luxo Professional Combination Clamp-On Lamps,Beth Paige,8995,737.94,102.3,21.26,Northwest Territories,Office Furnishings,0.59
82,Xerox 217,Beth Paige,8995,-191.28,6.48,8.19,Northwest Territories,Paper,0.37
83,Revere Boxed Rubber Bands by Revere,Beth Paige,8995,-21.49,1.89,0.76,Northwest Territories,Rubber Bands,0.83
84,"Acco Smartsocket™ Table Surge Protector, 6 Color-Coded Adapter Outlets",Sylvia Foulston,9126,884.08,62.05,3.99,Northwest Territories,Appliances,0.55
85,"Tennsco Snap-Together Open Shelving Units, Starter Sets and Add-On Units",Bryan Davis,9127,-329.49,279.48,35,Northwest Territories,Storage & Organization,0.8
86,Hon 4070 Series Pagoda™ Round Back Stacking Chairs,Joy Bell,9509,2825.15,320.98,58.95,Northwest Territories,Chairs & Chairmats,0.57
87,Xerox 1887,Joy Bell,9509,2.13,18.97,5.21,Northwest Territories,Paper,0.37
88,Xerox 1891,Joy Bell,9509,707.15,48.91,5.81,Northwest Territories,Paper,0.38
89,Avery 506,Alan Barnes,9763,75.13,4.13,0.5,Northwest Territories,Labels,0.39
90,"Bush Heritage Pine Collection 5-Shelf Bookcase, Albany Pine Finish, *Special Order",Grant Carroll,9927,-270.63,140.98,53.48,Northwest Territories,Bookcases,0.65
91,"Lifetime Advantage™ Folding Chairs, 4/Carton",Grant Carroll,9927,3387.35,218.08,18.06,Northwest Territories,Chairs & Chairmats,0.57
92,Microsoft Natural Multimedia Keyboard,Grant Carroll,9927,-82.16,50.98,6.5,Northwest Territories,Computer Peripherals,0.73
93,"Staples Wirebound Steno Books, 6 x 9, 12/Pack",Delfina Latchford,10022,-3.88,10.14,2.27,Northwest Territories,Paper,0.36
94,"GBC Pre-Punched Binding Paper, Plastic, White, 8-1/2 x 11",Don Jones,10437,-191.22,15.99,13.18,Northwest Territories,Binders and Binder Accessories,0.37
95,Bevis Boat-Shaped Conference Table,Doug Bickford,10499,31.21,262.11,62.74,Northwest Territories,Tables,0.75
96,"Linden® 12 Wall Clock With Oak Frame",Doug Bickford,10535,-44.14,33.98,19.99,Northwest Territories,Office Furnishings,0.55
97,Newell 326,Doug Bickford,10535,-0.79,1.76,0.7,Northwest Territories,Pens & Art Supplies,0.56
98,Prismacolor Color Pencil Set,Jamie Kunitz,10789,76.42,19.84,4.1,Northwest Territories,Pens & Art Supplies,0.44
99,Xerox Blank Computer Paper,Anthony Johnson,10791,93.36,19.98,5.77,Northwest Territories,Paper,0.38
100,600 Series Flip,Ralph Knight,10945,4.22,95.99,8.99,Northwest Territories,Telephones and Communication,0.57
101,Fellowes Recycled Storage Drawers,Allen Rosenblatt,11137,395.12,111.03,8.64,Northwest Territories,Storage & Organization,0.78
102,Satellite Sectional Post Binders,Barry Weirich,11202,79.59,43.41,2.99,Northwest Territories,Binders and Binder Accessories,0.39
103,Deflect-o DuraMat Antistatic Studded Beveled Mat for Medium Pile Carpeting,Doug Bickford,11456,399.37,105.34,24.49,Northwest Territories,Office Furnishings,0.61
104,Avery 487,Carl Jackson,11460,37.79,3.69,0.5,Northwest Territories,Labels,0.38
105,Bevis Round Conference Table Top & Single Column Base,Brendan Dodson,11495,-144.20,146.34,43.75,Northwest Territories,Tables,0.65
106,"GBC Twin Loop™ Wire Binding Elements, 9/16 Spine, Black",Edward Hooks,11911,-14.75,15.22,9.73,Northwest Territories,Binders and Binder Accessories,0.36
107,Hanging Personal Folder File,Jamie Kunitz,11941,-41.01,15.7,11.25,Northwest Territories,Storage & Organization,0.6
108,"Bevis Round Conference Table Top, X-Base",Jamie Kunitz,11941,111.52,179.29,29.21,Northwest Territories,Tables,0.74
109,5125,Michelle Lonsdale,12096,2332.40,200.99,8.08,Northwest Territories,Telephones and Communication,0.59
110,Electrix Halogen Magnifier Lamp,Michelle Lonsdale,12096,2176.19,194.3,11.54,Northwest Territories,Office Furnishings,0.59
111,Canon BP1200DH 12-Digit Bubble Jet Printing Calculator,Brendan Dodson,12289,1269.05,120.97,7.11,Northwest Territories,Office Machines,0.36
112,Fellowes Black Plastic Comb Bindings,Hunter Glantz,12352,-32.82,5.81,8.49,Northwest Territories,Binders and Binder Accessories,0.39
113,Polycom ViewStation™ Adapter H323 Videoconferencing Unit,Sylvia Foulston,12419,5322.14,1938.02,13.99,Northwest Territories,Office Machines,0.38
114,Hon GuestStacker Chair,Eugene Barchas,12485,1068.48,226.67,28.16,Northwest Territories,Chairs & Chairmats,0.59
115,Eldon® Wave Desk Accessories,Jim Radford,12544,-129.01,2.08,5.33,Northwest Territories,Office Furnishings,0.43
116,Sharp AL-1530CS Digital Copier,Carlos Soltero,12704,1260.51,499.99,24.49,Northwest Territories,Copiers and Fax,0.36
117,"Tennsco Lockers, Gray",Carlos Soltero,12704,-1274.02,20.98,53.03,Northwest Territories,Storage & Organization,0.78
118,"Avery 4027 File Folder Labels for Dot Matrix Printers, 5000 Labels per Box, White",Carlos Soltero,12771,-193.44,30.53,19.99,Northwest Territories,Labels,0.39
119,Newell 323,Carlos Soltero,12771,-43.10,1.68,1.57,Northwest Territories,Pens & Art Supplies,0.59
120,Global Enterprise Series Seating High-Back Swivel/Tilt Chairs,Jim Radford,12929,-158.93,270.98,50,Northwest Territories,Chairs & Chairmats,0.77
121,Spiral Phone Message Books with Labels by Adams,Jim Radford,12929,29.68,4.48,1.22,Northwest Territories,Paper,0.36
122,Crate-A-Files™,Grant Carroll,13280,-116.76,10.9,7.46,Northwest Territories,Storage & Organization,0.59
123,Bell Sonecor JB700 Caller ID,Grant Carroll,13280,-160.95,7.99,5.03,Northwest Territories,Telephones and Communication,0.6
124,Holmes 99% HEPA Air Purifier,Skye Norling,13313,-209.61,21.66,13.99,Northwest Territories,Appliances,0.52
125,Xerox 224,Doug Bickford,13346,-240.83,6.48,8.88,Northwest Territories,Paper,0.37
126,Xerox 1906,Grant Carroll,13702,12.32,35.44,7.5,Northwest Territories,Paper,0.38
127,"GBC Pre-Punched Binding Paper, Plastic, White, 8-1/2 x 11",Muhammed MacIntyre,13795,-119.08,15.99,13.18,Northwest Territories,Binders and Binder Accessories,0.37
128,Xerox 188,Muhammed MacIntyre,13795,43.35,11.34,5.01,Northwest Territories,Paper,0.36
129,Xerox 1932,Muhammed MacIntyre,13795,545.49,35.44,5.09,Northwest Territories,Paper,0.38
130,GBC Linen Binding Covers,Doug Bickford,14116,-16.07,30.98,11.63,Northwest Territories,Binders and Binder Accessories,0.37
131,GBC Recycled Grain Textured Covers,Doug Bickford,14116,161.48,34.54,14.72,Northwest Territories,Binders and Binder Accessories,0.37
132,"Sauder Facets Collection Library, Sky Alder Finish",Beth Thompson,14372,-1059.20,170.98,60.49,Northwest Territories,Bookcases,0.69
133,"Fellowes Basic 104-Key Keyboard, Platinum",Ralph Knight,14726,-21.48,20.95,4,Northwest Territories,Computer Peripherals,0.6
134,Kensington 7 Outlet MasterPiece Power Center with Fax/Phone Line Protection,Carl Jackson,14819,3122.78,207.48,0.99,Northwest Territories,Appliances,0.55
135,O'Sullivan 3-Shelf Heavy-Duty Bookcases,Carl Jackson,14819,-478.22,58.14,36.61,Northwest Territories,Bookcases,0.61
136,G.E. Longer-Life Indoor Recessed Floodlight Bulbs,Dorothy Badders,15106,-14.23,6.64,4.95,Northwest Territories,Office Furnishings,0.37
137,Panasonic KX-P1150 Dot Matrix Printer,Dorothy Badders,15106,948.79,145.45,17.85,Northwest Territories,Office Machines,0.56
138,Newell 327,Dorothy Badders,15106,-6.33,2.21,1.12,Northwest Territories,Pens & Art Supplies,0.58
139,Xerox 1893,Delfina Latchford,15108,372.36,40.99,17.48,Northwest Territories,Paper,0.36
140,"Hon Deluxe Fabric Upholstered Stacking Chairs, Rounded Back",Julia West,15205,678.26,243.98,43.32,Northwest Territories,Chairs & Chairmats,0.55
141,Eldon Radial Chair Mat for Low to Medium Pile Carpets,Julia West,15205,155.72,39.98,9.2,Northwest Territories,Office Furnishings,0.65
142,"DAX Copper Panel Document Frame, 5 x 7 Size",Brad Eason,15591,73.53,12.58,5.16,Northwest Territories,Office Furnishings,0.43
143,O'Sullivan 2-Shelf Heavy-Duty Bookcases,Thomas Seio,15907,-1414.41,48.58,54.11,Northwest Territories,Bookcases,0.69
144,"Tenex 46 x 60 Computer Anti-Static Chairmat, Rectangular Shaped",Thomas Seio,15907,950.68,105.98,13.99,Northwest Territories,Office Furnishings,0.65
145,"Wirebound Message Books, 2 7/8 x 5, 3 Forms per Page",Thomas Seio,15907,-5.41,7.04,2.17,Northwest Territories,Paper,0.38
146,"Memorex Slim 80 Minute CD-R, 10/Pack",Monica Federle,15937,74.07,9.78,1.99,Northwest Territories,Computer Peripherals,0.43
147,Aluminum Document Frame,Monica Federle,15937,77.38,12.22,2.85,Northwest Territories,Office Furnishings,0.55
148,"Memorex 80 Minute CD-R Spindle, 100/Pack",Michelle Lonsdale,16039,-118.82,43.98,1.99,Northwest Territories,Computer Peripherals,0.44
149,"Multi-Use Personal File Cart and Caster Set, Three Stacking Bins",Frank Price,16193,6.41,34.76,8.22,Northwest Territories,Storage & Organization,0.57
150,Accessory36,Frank Price,16193,-183.68,55.99,5,Northwest Territories,Telephones and Communication,0.83
151,Xerox 20,Bryan Davis,16423,-55.13,6.48,6.57,Northwest Territories,Paper,0.37
152,Surelock™ Post Binders,Don Jones,16451,58.23,30.56,2.99,Northwest Territories,Binders and Binder Accessories,0.35
153,Colorific® Watercolor Pencils,Carlos Soltero,16545,4.45,5.16,0.73,Northwest Territories,Pens & Art Supplies,0.56
154,"*Staples* vLetter Openers, 2/Pack",Carlos Soltero,16545,-3.06,3.68,1.32,Northwest Territories,"Scissors, Rulers and Trimmers",0.83
155,Hon 4700 Series Mobuis™ Mid-Back Task Chairs with Adjustable Arms,Nicole Hansen,16547,1240.25,355.98,58.92,Northwest Territories,Chairs & Chairmats,0.64
156,BoxOffice By Design Rectangular and Half-Moon Meeting Room Tables,Nicole Hansen,16547,-533.23,218.75,69.64,Northwest Territories,Tables,0.77
157,Eldon Econocleat® Chair Mats for Low Pile Carpets,Beth Thompson,16706,-1003.58,41.47,34.2,Northwest Territories,Office Furnishings,0.73
158,Prang Drawing Pencil Set,Beth Thompson,16706,-4.06,2.78,1.2,Northwest Territories,Pens & Art Supplies,0.58
159,T39m,Beth Thompson,16706,1881.58,155.99,3.9,Northwest Territories,Telephones and Communication,0.55
160,Xerox 1982,Nicole Hansen,16741,-42.38,22.84,16.87,Northwest Territories,Paper,0.39
161,Xerox 1924,Carlos Soltero,16932,-120.99,5.78,8.09,Northwest Territories,Paper,0.36
162,Turquoise Lead Holder with Pocket Clip,Carlos Soltero,16932,12.88,6.7,1.56,Northwest Territories,Pens & Art Supplies,0.52
163,Okidata ML395C Color Dot Matrix Printer,Dorothy Badders,17283,-2816.34,1360.14,14.7,Northwest Territories,Office Machines,0.59
164,Global Enterprise Series Seating High-Back Swivel/Tilt Chairs,Muhammed MacIntyre,17286,-541.87,270.98,50,Northwest Territories,Chairs & Chairmats,0.77
165,Microsoft Internet Keyboard,Muhammed MacIntyre,17409,-158.87,20.97,6.5,Northwest Territories,Computer Peripherals,0.78
166,Xerox 1982,Don Miller,17764,-97.28,22.84,16.87,Northwest Territories,Paper,0.39
167,Global Ergonomic Managers Chair,Sylvia Foulston,18080,-80.83,180.98,26.2,Northwest Territories,Chairs & Chairmats,0.59
168,"Office Star - Contemporary Task Swivel chair with 2-way adjustable arms, Plum",Becky Castell,18113,-514.32,130.98,30,Northwest Territories,Chairs & Chairmats,0.78
169,Xerox 1971,Dorothy Wardle,18144,-131.82,4.28,5.17,Northwest Territories,Paper,0.4
170,Eldon Portable Mobile Manager,Dorothy Wardle,18144,-65.42,28.28,13.99,Northwest Territories,Storage & Organization,0.58
171,Accessory6,Dorothy Wardle,18144,-250.17,55.99,5,Northwest Territories,Telephones and Communication,0.8
172,Durable Pressboard Binders,Ann Chong,18308,15.73,3.8,1.49,Northwest Territories,Binders and Binder Accessories,0.38
173,Fellowes 17-key keypad for PS/2 interface,Ann Chong,18308,-92.58,30.73,4,Northwest Territories,Computer Peripherals,0.75
174,StarTAC ST7762,Ann Chong,18308,1465.87,125.99,8.08,Northwest Territories,Telephones and Communication,0.57
175,Accessory21,Clay Rozendal,18887,18.23,20.99,0.99,Northwest Territories,Telephones and Communication,0.37
176,Fellowes PB500 Electric Punch Plastic Comb Binding Machine with Manual Bind,Grant Carroll,19010,10951.31,1270.99,19.99,Northwest Territories,Binders and Binder Accessories,0.35
177,Staples 6 Outlet Surge,Brendan Dodson,19078,-18.19,11.97,4.98,Northwest Territories,Appliances,0.58
178,Recycled Eldon Regeneration Jumbo File,Carlos Daly,19138,-31.45,12.28,6.13,Northwest Territories,Storage & Organization,0.57
179,Verbatim DVD-R 4.7GB authoring disc,Alan Barnes,19655,304.42,39.24,1.99,Northwest Territories,Computer Peripherals,0.51
180,Canon P1-DHIII Palm Printing Calculator,Alan Barnes,19686,-53.08,17.98,8.51,Northwest Territories,Office Machines,0.4
181,GBC Binding covers,Alan Barnes,19686,12.76,12.95,4.98,Northwest Territories,Binders and Binder Accessories,0.4
182,Newell 323,Nicole Hansen,20007,-46.25,1.68,1.57,Northwest Territories,Pens & Art Supplies,0.59
183,"Global Stack Chair without Arms, Black",Cari Schnelling,20071,-190.41,25.98,14.36,Northwest Territories,Chairs & Chairmats,0.6
184,"Speediset Carbonless Redi-Letter® 7 x 8 1/2",Chad Cunningham,20160,174.89,10.31,1.79,Northwest Territories,Paper,0.38
185,GBC Recycled Regency Composition Covers,Bryan Mills,20263,72.51,59.78,10.29,Northwest Territories,Binders and Binder Accessories,0.39
186,Accessory29,Bryan Mills,20263,-76.86,20.99,1.25,Northwest Territories,Telephones and Communication,0.83
187,Newell 323,Adrian Hane,21285,-30.54,1.68,1.57,Northwest Territories,Pens & Art Supplies,0.59
188,SANFORD Major Accent™ Highlighters,Adrian Hane,21285,23.82,7.08,2.35,Northwest Territories,Pens & Art Supplies,0.47
189,Polycom ViaVideo™ Desktop Video Communications Unit,Rick Reed,21383,7416.43,574.74,24.49,Northwest Territories,Office Machines,0.37
190,"Dixon Ticonderoga Core-Lock Colored Pencils, 48-Color Set",Heather Kirkland,21607,54.92,36.55,13.89,Northwest Territories,Pens & Art Supplies,0.41
191,Accessory24,Fred Wasserman,21636,366.51,55.99,3.3,Northwest Territories,Telephones and Communication,0.59
192,"Howard Miller 13-3/4 Diameter Brushed Chrome Round Wall Clock",Becky Castell,21889,135.79,51.75,19.99,Northwest Territories,Office Furnishings,0.55
193,Recycled Steel Personal File for Standard File Folders,Becky Castell,21889,103.38,55.29,5.08,Northwest Territories,Storage & Organization,0.59
194,"Eldon Expressions™ Desk Accessory, Wood Pencil Holder, Oak",Beth Thompson,22151,-79.72,9.65,6.22,Northwest Territories,Office Furnishings,0.55
195,Accessory39,Claudia Miner,22342,-92.96,20.99,3.3,Northwest Territories,Telephones and Communication,0.81
196,Bell Sonecor JB700 Caller ID,Jack Lebron,22469,-162.37,7.99,5.03,Northwest Territories,Telephones and Communication,0.6
197,"#10- 4 1/8 x 9 1/2 Security-Tint Envelopes",Alan Barnes,22501,7.27,7.64,1.39,Northwest Territories,Envelopes,0.36
198,GBC Standard Plastic Binding Systems Combs,Carlos Soltero,22532,-11.80,8.85,5.6,Northwest Territories,Binders and Binder Accessories,0.36
199,Xerox 1930,Clay Rozendal,23264,-50.82,6.48,6.81,Northwest Territories,Paper,0.36
200,Avery 474,Clay Rozendal,23264,17.99,2.88,0.99,Northwest Territories,Labels,0.36
201,"Riverside Palais Royal Lawyers Bookcase, Royale Cherry Finish",Julia West,23488,-11053.60,880.98,44.55,Northwest Territories,Bookcases,0.62
202,Hewlett-Packard Deskjet 6122 Color Inkjet Printer,Alan Barnes,23584,636.18,200.97,15.59,Northwest Territories,Office Machines,0.36
203,"IBM 80 Minute CD-R Spindle, 50/Pack",Joy Bell,24007,135.65,20.89,1.99,Northwest Territories,Computer Peripherals,0.48
204,"Peel & Seel® Recycled Catalog Envelopes, Brown",Joy Bell,24007,-13.95,11.58,6.97,Northwest Territories,Envelopes,0.35
205,Avery 506,Joy Bell,24007,66.17,4.13,0.5,Northwest Territories,Labels,0.39
206,Prang Drawing Pencil Set,Jack Lebron,24038,-0.95,2.78,1.34,Northwest Territories,Pens & Art Supplies,0.45
207,TDK 4.7GB DVD+RW,Anthony Johnson,24097,-35.34,14.48,1.99,Northwest Territories,Computer Peripherals,0.49
208,U.S. Robotics 56K Internet Call Modem,Anthony Johnson,24097,399.93,99.99,19.99,Northwest Territories,Computer Peripherals,0.5
209,Xerox 190,Anthony Johnson,24097,-8.15,4.98,4.86,Northwest Territories,Paper,0.38
210,Standard Line™ “While You Were Out” Hardbound Telephone Message Book,Eugene Barchas,24128,7.07,21.98,8.32,Northwest Territories,Paper,0.39
211,CF 888,Eugene Barchas,24128,1459.79,195.99,3.99,Northwest Territories,Telephones and Communication,0.59
212,Hewlett-Packard Deskjet 6122 Color Inkjet Printer,Thomas Seio,24294,1951.30,200.97,15.59,Northwest Territories,Office Machines,0.36
213,Dana Halogen Swing-Arm Architect Lamp,Bryan Mills,24387,51.90,40.97,14.45,Northwest Territories,Office Furnishings,0.57
214,"SAFCO PlanMaster Heigh-Adjustable Drafting Table Base, 43w x 30d x 30-37h, Black",Bryan Mills,24387,1418.36,349.45,60,Northwest Territories,Tables,
215,Lexmark Z25 Color Inkjet Printer,Eugene Barchas,24515,121.48,80.97,33.6,Northwest Territories,Office Machines,0.37
216,Hon Multipurpose Stacking Arm Chairs,Sylvia Foulston,24743,176.67,216.6,64.2,Northwest Territories,Chairs & Chairmats,0.59
217,Hon Olson Stacker Stools,Sylvia Foulston,24743,753.61,140.81,24.49,Northwest Territories,Chairs & Chairmats,0.57
218,"Executive Impressions 14 Two-Color Numerals Wall Clock",Carl Ludwig,24871,75.30,22.72,8.99,Northwest Territories,Office Furnishings,0.44
219,12-1/2 Diameter Round Wall Clock,Julia West,25318,-65.18,19.98,10.49,Northwest Territories,Office Furnishings,0.49
220,Epson DFX5000+ Dot Matrix Printer,Don Jones,25377,-3755.03,1500.97,29.7,Northwest Territories,Office Machines,0.57
221,"Fellowes Basic 104-Key Keyboard, Platinum",Mike Pelletier,25634,28.99,20.95,4,Northwest Territories,Computer Peripherals,0.6
222,"Recycled Interoffice Envelopes with String and Button Closure, 10 x 13",Mike Pelletier,25634,185.32,23.99,6.71,Northwest Territories,Envelopes,0.35
223,GBC Standard Therm-A-Bind Covers,Eugene Barchas,25733,-42.99,24.92,12.98,Northwest Territories,Binders and Binder Accessories,0.39
224,"80 Minute CD-R Spindle, 100/Pack - Staples",Ann Chong,25767,-59.20,39.48,1.99,Northwest Territories,Computer Peripherals,0.54
225,Xerox 1892,Ann Chong,25767,108.01,38.76,13.26,Northwest Territories,Paper,0.36
226,Staples Paper Clips,Charles McCrossin,26023,19.86,2.47,1.02,Northwest Territories,Rubber Bands,0.38
227,"Metal Folding Chairs, Beige, 4/Carton",Annie Cyprus,26051,-127.39,33.94,19.19,Northwest Territories,Chairs & Chairmats,0.58
228,"80 Minute Slim Jewel Case CD-R , 10/Pack - Staples",Annie Cyprus,26051,22.46,8.33,1.99,Northwest Territories,Computer Peripherals,0.52
229,Computer Printout Paper with Letter-Trim Perforations,Carlos Soltero,26116,81.71,18.97,9.03,Northwest Territories,Paper,0.37
230,Bush Mission Pointe Library,Doug Bickford,26182,-549.27,150.98,66.27,Northwest Territories,Bookcases,0.65
231,Hon Olson Stacker Stools,Carlos Daly,26272,-4.19,140.81,24.49,Northwest Territories,Chairs & Chairmats,0.57
232,Xerox 1929,Fred Wasserman,26370,52.02,22.84,5.47,Northwest Territories,Paper,0.39
233,Home/Office Personal File Carts,Fred Wasserman,26370,63.83,34.76,5.49,Northwest Territories,Storage & Organization,0.6
234,Avery 507,Sylvia Foulston,26499,8.78,2.88,0.5,Northwest Territories,Labels,0.39
235,i470,Michelle Lonsdale,26531,1215.44,205.99,5.26,Northwest Territories,Telephones and Communication,0.56
236,3M Organizer Strips,Sylvia Foulston,26567,-44.07,5.4,7.78,Northwest Territories,Binders and Binder Accessories,0.37
237,"Imation 3.5 IBM Diskettes, 10/Box",Sylvia Foulston,26567,-100.51,8.46,8.99,Northwest Territories,Computer Peripherals,0.79
238,"GE 4 Foot Flourescent Tube, 40 Watt",Sylvia Foulston,26567,-17.75,14.98,8.99,Northwest Territories,Office Furnishings,0.39
239,300 Series Non-Flip,Sylvia Foulston,26567,1374.95,155.99,8.08,Northwest Territories,Telephones and Communication,0.6
240,"Executive Impressions 13 Chairman Wall Clock",Charlotte Melton,26854,-12.95,25.38,8.99,Northwest Territories,Office Furnishings,0.5
241,Micro Innovations 104 Keyboard,Barry French,27109,-154.66,10.97,6.5,Northwest Territories,Computer Peripherals,0.64
242,US Robotics 56K V.92 External Faxmodem,Heather Kirkland,27111,-127.56,99.99,19.99,Northwest Territories,Computer Peripherals,0.52
243,Fellowes Staxonsteel® Drawer Files,Heather Kirkland,27111,282.18,193.17,19.99,Northwest Territories,Storage & Organization,0.71
244,Accessory39,Heather Kirkland,27111,-96.34,20.99,3.3,Northwest Territories,Telephones and Communication,0.81
245,Telescoping Adjustable Floor Lamp,Henry Goldwyn,27264,44.54,19.99,11.17,Northwest Territories,Office Furnishings,0.6
246,Canon MP41DH Printing Calculator,Frank Price,27392,2509.52,150.98,13.99,Northwest Territories,Office Machines,0.38
247,"Sauder Facets Collection Locker/File Cabinet, Sky Alder Finish",Jim Radford,27553,1166.93,370.98,99,Northwest Territories,Storage & Organization,0.65
248,VTech VT20-2481 2.4GHz Two-Line Phone System w/Answering Machine,Jim Radford,27553,297.11,179.99,13.99,Northwest Territories,Telephones and Communication,0.57
249,"Memo Book, 100 Message Capacity, 5 3/8” x 11”",Ralph Knight,27555,65.41,6.74,1.72,Northwest Territories,Paper,0.35
250,Belkin 6 Outlet Metallic Surge Strip,Delfina Latchford,27680,-46.98,10.89,4.5,Northwest Territories,Appliances,0.59
251,Xerox 21,Delfina Latchford,27680,-46.89,6.48,6.6,Northwest Territories,Paper,0.37
252,GBC DocuBind TL200 Manual Binding Machine,Roy Skaria,27778,-105.14,223.98,15.01,Northwest Territories,Binders and Binder Accessories,0.38
253,"Sauder Forest Hills Library, Woodland Oak Finish",Roy Skaria,27778,-393.96,140.98,36.09,Northwest Territories,Bookcases,0.77
254,Xerox 1940,Monica Federle,27909,-23.24,54.96,10.75,Northwest Territories,Paper,0.36
255,Bagged Rubber Bands,Monica Federle,27909,-24.86,1.26,0.7,Northwest Territories,Rubber Bands,0.81
256,Xerox 1897,Charles McCrossin,28003,-95.92,4.98,6.07,Northwest Territories,Paper,0.36
257,Poly Designer Cover & Back,Don Miller,28035,89.56,18.99,5.23,Northwest Territories,Binders and Binder Accessories,0.37
258,Bionaire Personal Warm Mist Humidifier/Vaporizer,Jeremy Lonsdale,28135,520.69,46.89,5.1,Northwest Territories,Appliances,0.46
259,"Acme® 8 Straight Scissors",Jeremy Lonsdale,28135,38.23,12.98,3.14,Northwest Territories,"Scissors, Rulers and Trimmers",0.6
260,Heavy-Duty E-Z-D® Binders,Grant Carroll,28165,-12.80,10.91,2.99,Northwest Territories,Binders and Binder Accessories,0.38
261,Hammermill CopyPlus Copy Paper (20Lb. and 84 Bright),Carl Ludwig,28289,-46.03,4.98,4.75,Northwest Territories,Paper,0.36
262,Deluxe Rollaway Locking File with Drawer,Carlos Daly,28486,-517.47,415.88,11.37,Northwest Territories,Storage & Organization,0.57
263,252,Ralph Knight,28675,4.39,65.99,5.92,Northwest Territories,Telephones and Communication,0.55
264,6160,Cindy Schnelling,28870,822.40,115.99,2.5,Northwest Territories,Telephones and Communication,0.57
265,"Imation 3.5, DISKETTE 44766 HGHLD3.52HD/FM, 10/Pack",Claudia Miner,28871,-56.12,5.02,5.14,Northwest Territories,Computer Peripherals,0.79
266,Prismacolor Color Pencil Set,Roy Skaria,29030,24.60,19.84,4.1,Northwest Territories,Pens & Art Supplies,0.44
267,Wilson Jones DublLock® D-Ring Binders,Delfina Latchford,29095,54.46,6.75,2.99,Northwest Territories,Binders and Binder Accessories,0.35
268,Binder Posts,Edward Hooks,29287,-106.40,5.74,5.01,Northwest Territories,Binders and Binder Accessories,0.39
269,Epson LQ-570e Dot Matrix Printer,Edward Hooks,29287,2699.67,270.97,28.06,Northwest Territories,Office Machines,0.56
270,"Atlantic Metals Mobile 3-Shelf Bookcases, Custom Colors",Don Miller,29510,1292.44,260.98,41.91,Northwest Territories,Bookcases,0.59
271,Fellowes PB300 Plastic Comb Binding Machine,Grant Carroll,29795,8793.54,387.99,19.99,Northwest Territories,Binders and Binder Accessories,0.38
272,Rush Hierlooms Collection Rich Wood Bookcases,Grant Carroll,29795,813.83,160.98,35.02,Northwest Territories,Bookcases,0.72
273,Avery 481,Brad Eason,29861,5.58,3.08,0.99,Northwest Territories,Labels,0.37
274,Sharp AL-1530CS Digital Copier,Charles McCrossin,30658,6907.61,499.99,24.49,Northwest Territories,Copiers and Fax,0.36
275,"SAFCO Commercial Wire Shelving, Black",Charles McCrossin,30658,-942.50,138.14,35,Northwest Territories,Storage & Organization,
276,"Avery Trapezoid Extra Heavy Duty 4 Binders",Charles McCrossin,30947,261.24,41.94,2.99,Northwest Territories,Binders and Binder Accessories,0.35
277,Self-Adhesive Address Labels for Typewriters by Universal,Charles McCrossin,30947,183.53,7.31,0.49,Northwest Territories,Labels,0.38
278,StarTAC Series,Bryan Mills,31077,470.83,65.99,3.9,Northwest Territories,Telephones and Communication,0.55
279,"Rediform Wirebound Phone Memo Message Book, 11 x 5-3/4",Monica Federle,31111,-29.02,7.64,5.83,Northwest Territories,Paper,0.36
280,Dana Halogen Swing-Arm Architect Lamp,Michelle Lonsdale,31169,109.88,40.97,14.45,Northwest Territories,Office Furnishings,0.57
281,Global Comet™ Stacking Armless Chair,Michelle Lonsdale,31270,801.72,299.05,87.01,Northwest Territories,Chairs & Chairmats,0.57
282,Hon 4070 Series Pagoda™ Armless Upholstered Stacking Chairs,Michelle Lonsdale,31270,-328.36,291.73,48.8,Northwest Territories,Chairs & Chairmats,0.56
283,"Fellowes Internet Keyboard, Platinum",Michelle Lonsdale,31270,-112.44,30.42,8.65,Northwest Territories,Computer Peripherals,0.74
284,Deluxe Rollaway Locking File with Drawer,Beth Thompson,31364,-539.59,415.88,11.37,Northwest Territories,Storage & Organization,0.57
285,Luxo Economy Swing Arm Lamp,Cindy Schnelling,31393,-27.31,19.94,14.87,Northwest Territories,Office Furnishings,0.57
286,"*Staples* vLetter Openers, 2/Pack",Cindy Schnelling,31393,-32.65,3.68,1.32,Northwest Territories,"Scissors, Rulers and Trimmers",0.83
287,Staples 6 Outlet Surge,Nicole Hansen,31492,-12.25,11.97,4.98,Northwest Territories,Appliances,0.58
288,Acco Perma® 2700 Stacking Storage Drawers,Nicole Hansen,31492,-21.10,29.74,6.64,Northwest Territories,Storage & Organization,0.7
289,Fellowes Stor/Drawer® Steel Plus™ Storage Drawers,Nicole Hansen,31492,-235.56,95.43,19.99,Northwest Territories,Storage & Organization,0.79
290,Honeywell Enviracaire Portable HEPA Air Cleaner for 17' x 22' Room,Cari Schnelling,31558,900.06,300.65,24.49,Northwest Territories,Appliances,0.52
291,"Verbatim DVD-RAM, 9.4GB, Rewritable, Type 1, DS, DataLife Plus",Cari Schnelling,31558,455.37,45.19,1.99,Northwest Territories,Computer Peripherals,0.55
292,Lock-Up Easel 'Spel-Binder',Roy Skaria,31618,147.45,28.53,1.49,Northwest Territories,Binders and Binder Accessories,0.38
293,"Adams Write n' Stick Phone Message Book, 11 X 5 1/4, 200 Messages",Susan Vittorini,31684,23.48,5.68,1.46,Northwest Territories,Paper,0.39
294,"Tenex File Box, Personal Filing Tote with Lid, Black",Susan Vittorini,31684,-328.18,15.51,17.78,Northwest Territories,Storage & Organization,0.59
295,Fellowes Black Plastic Comb Bindings,Sylvia Foulston,31781,-282.61,5.81,8.49,Northwest Territories,Binders and Binder Accessories,0.39
296,Assorted Color Push Pins,Sylvia Foulston,31781,5.53,1.81,0.75,Northwest Territories,Rubber Bands,0.52
297,HP Office Paper (20Lb. and 87 Bright),Chad Cunningham,32193,-10.25,6.68,6.93,Northwest Territories,Paper,0.37
298,Staples Vinyl Coated Paper Clips,Chad Cunningham,32193,37.33,3.93,0.99,Northwest Territories,Rubber Bands,0.39
299,Canon MP41DH Printing Calculator,Carlos Daly,32229,44.37,150.98,13.99,Northwest Territories,Office Machines,0.38
300,Newell 310,Carlos Daly,32229,-0.12,1.76,0.7,Northwest Territories,Pens & Art Supplies,0.56
301,Kensington 7 Outlet MasterPiece Power Center,Grant Carroll,32743,1280.19,177.98,0.99,Northwest Territories,Appliances,0.56
302,"DAX Metal Frame, Desktop, Stepped-Edge",Julia West,32806,-28.34,20.24,8.99,Northwest Territories,Office Furnishings,0.46
303,Bush Mission Pointe Library,Roy Skaria,33123,-996.67,150.98,66.27,Northwest Territories,Bookcases,0.65
304,Accessory21,Cindy Schnelling,33159,-70.97,20.99,0.99,Northwest Territories,Telephones and Communication,0.37
305,8860,Don Jones,33186,221.18,65.99,5.26,Northwest Territories,Telephones and Communication,0.56
306,Array® Memo Cubes,Beth Thompson,33377,11.94,5.18,2.04,Northwest Territories,Paper,0.36
307,"Fiskars 8 Scissors, 2/Pack",Beth Thompson,33377,47.30,17.24,3.26,Northwest Territories,"Scissors, Rulers and Trimmers",0.56
308,12 Colored Short Pencils,Alan Barnes,33444,-17.68,2.6,2.4,Northwest Territories,Pens & Art Supplies,0.58
309,Pizazz® Global Quick File™,Alan Barnes,33444,-30.48,14.97,7.51,Northwest Territories,Storage & Organization,0.57
310,Imation 5.2GB DVD-RAM,Carl Ludwig,33703,-131.48,60.98,1.99,Northwest Territories,Computer Peripherals,0.5
311,Acco Perma® 2700 Stacking Storage Drawers,Carl Ludwig,33703,56.26,29.74,6.64,Northwest Territories,Storage & Organization,0.7
312,Portable Personal File Box,Carl Ludwig,33703,-8.47,12.21,4.81,Northwest Territories,Storage & Organization,0.58
313,"Snap-A-Way® Black Print Carbonless Speed Message, No Reply Area, Duplicate",Jamie Kunitz,33734,106.53,29.14,4.86,Northwest Territories,Paper,0.38
314,Ibico Covers for Plastic or Wire Binding Elements,Heather Kirkland,33888,-44.92,11.5,7.19,Northwest Territories,Binders and Binder Accessories,0.4
315,Hanging Personal Folder File,Heather Kirkland,33888,-35.08,15.7,11.25,Northwest Territories,Storage & Organization,0.6
316,Tennsco Double-Tier Lockers,Heather Kirkland,33888,965.48,225.02,28.66,Northwest Territories,Storage & Organization,0.72
317,"Wirebound Message Books, Four 2 3/4 x 5 Forms per Page, 600 Sets per Book",Doug Bickford,33894,11.34,9.27,4.39,Northwest Territories,Paper,0.38
318,"Acme Design Line 8 Stainless Steel Bent Scissors w/Champagne Handles, 3-1/8 Cut",Doug Bickford,33894,-32.48,6.84,8.37,Northwest Territories,"Scissors, Rulers and Trimmers",0.58
319,"Imation 3.5, DISKETTE 44766 HGHLD3.52HD/FM, 10/Pack",Doug Bickford,33894,-173.15,4.98,4.62,Northwest Territories,Computer Peripherals,0.64
320,PC Concepts 116 Key Quantum 3000 Keyboard,Doug Bickford,33894,-119.02,32.98,5.5,Northwest Territories,Computer Peripherals,0.75
321,Epson Stylus 1520 Color Inkjet Printer,Carlos Daly,33922,5353.19,500.97,69.3,Northwest Territories,Office Machines,0.37
322,Avery 494,Toby Braunhardt,34177,9.47,2.61,0.5,Northwest Territories,Labels,0.39
323,Self-Adhesive Address Labels for Typewriters by Universal,Toby Braunhardt,34177,73.18,7.31,0.49,Northwest Territories,Labels,0.38
324,Accessory37,Toby Braunhardt,34177,-83.95,20.99,2.5,Northwest Territories,Telephones and Communication,0.81
325,Wilson Jones 14 Line Acrylic Coated Pressboard Data Binders,Cari Schnelling,34215,-5.92,5.34,2.99,Northwest Territories,Binders and Binder Accessories,0.38
326,Eureka Disposable Bags for Sanitaire® Vibra Groomer I® Upright Vac,Thomas Seio,34246,-257.11,4.06,6.89,Northwest Territories,Appliances,0.6
327,AT&T 2230 Dual Handset Phone With Caller ID/Call Waiting,Thomas Seio,34246,192.33,99.99,19.99,Northwest Territories,Office Machines,0.52
328,"Peel & Seel® Recycled Catalog Envelopes, Brown",Thomas Seio,34246,1.91,11.58,6.97,Northwest Territories,Envelopes,0.35
329,Cardinal Poly Pocket Divider Pockets for Ring Binders,Brendan Dodson,34631,-22.28,3.36,6.27,Northwest Territories,Binders and Binder Accessories,0.4
330,Canon PC1060 Personal Laser Copier,Brendan Dodson,34631,2808.22,699.99,24.49,Northwest Territories,Copiers and Fax,0.41
331,Sterling Rubber Bands by Alliance,Charlotte Melton,35047,-7.06,4.71,0.7,Northwest Territories,Rubber Bands,0.85
332,Newell 312,Beth Thompson,35266,33.50,5.84,1.2,Northwest Territories,Pens & Art Supplies,0.55
333,BoxOffice By Design Rectangular and Half-Moon Meeting Room Tables,Beth Thompson,35266,-998.94,218.75,69.64,Northwest Territories,Tables,0.77
334,"Imation 3.5 DS/HD IBM Formatted Diskettes, 50/Pack",Eugene Barchas,35847,-144.27,15.98,8.99,Northwest Territories,Computer Peripherals,0.64
335,"Avery Flip-Chart Easel Binder, Black",Michelle Lonsdale,36001,-78.36,22.38,15.1,Northwest Territories,Binders and Binder Accessories,0.38
336,GBC Binding covers,Michelle Lonsdale,36001,51.82,12.95,4.98,Northwest Territories,Binders and Binder Accessories,0.4
337,R280,Grant Carroll,36134,-413.33,155.99,8.99,Northwest Territories,Telephones and Communication,0.55
338,Accessory9,Beth Paige,36135,381.17,35.99,3.3,Northwest Territories,Telephones and Communication,0.39
339,U.S. Robotics 56K Internet Call Modem,Dorothy Wardle,36644,218.72,99.99,19.99,Northwest Territories,Computer Peripherals,0.5
340,Tennsco Industrial Shelving,Muhammed MacIntyre,36646,-743.96,48.91,35,Northwest Territories,Storage & Organization,0.83
341,Staples Bulldog Clip,Charlotte Melton,36707,71.56,3.78,0.71,Northwest Territories,Rubber Bands,0.39
342,"Micro Innovations Micro 3000 Keyboard, Black",Muhammed MacIntyre,37253,-99.55,26.31,5.89,Northwest Territories,Computer Peripherals,0.75
343,"Fellowes Basic 104-Key Keyboard, Platinum",Claudia Miner,37541,-70.68,20.95,5.99,Northwest Territories,Computer Peripherals,0.65
344,Xerox 1882,Claudia Miner,37541,98.32,55.98,13.88,Northwest Territories,Paper,0.36
345,Carina Double Wide Media Storage Towers in Natural & Black,Claudia Miner,37541,-599.54,80.98,35,Northwest Territories,Storage & Organization,0.81
346,Portable Personal File Box,Brendan Dodson,37634,-36.78,12.21,4.81,Northwest Territories,Storage & Organization,0.58
347,"Acme Hot Forged Carbon Steel Scissors with Nickel-Plated Handles, 3 7/8 Cut, 8L",Dorothy Wardle,37793,-49.31,13.9,7.59,Northwest Territories,"Scissors, Rulers and Trimmers",0.56
348,Eldon Cleatmat® Chair Mats for Medium Pile Carpets,Mike Pelletier,37860,-98.31,55.5,52.2,Northwest Territories,Office Furnishings,0.72
349,Xerox 4200 Series MultiUse Premium Copy Paper (20Lb. and 84 Bright),Edward Hooks,38884,-119.84,5.28,5.66,Northwest Territories,Paper,0.4
350,Hon 94000 Series Round Tables,Edward Hooks,38884,-98.05,296.18,54.12,Northwest Territories,Tables,0.76
351,"Deflect-o RollaMat Studded, Beveled Mat for Medium Pile Carpeting",Jamie Kunitz,39364,-1.33,92.23,39.61,Northwest Territories,Office Furnishings,0.67
352,Fellowes PB500 Electric Punch Plastic Comb Binding Machine with Manual Bind,Jamie Kunitz,39364,8417.57,1270.99,19.99,Northwest Territories,Binders and Binder Accessories,0.35
353,"Global High-Back Leather Tilter, Burgundy",Julia West,39457,-1975.26,122.99,70.2,Northwest Territories,Chairs & Chairmats,0.74
354,Poly Designer Cover & Back,Jeremy Lonsdale,39683,168.00,18.99,5.23,Northwest Territories,Binders and Binder Accessories,0.37
355,"Lifetime Advantage™ Folding Chairs, 4/Carton",Jeremy Lonsdale,39683,2113.95,218.08,18.06,Northwest Territories,Chairs & Chairmats,0.57
356,"DAX Contemporary Wood Frame with Silver Metal Mat, Desktop, 11 x 14 Size",Jeremy Lonsdale,39683,66.97,20.24,6.67,Northwest Territories,Office Furnishings,0.49
357,Stockwell Push Pins,Jeremy Lonsdale,39683,6.37,2.18,0.78,Northwest Territories,Rubber Bands,0.52
358,"Imation 3.5, DISKETTE 44766 HGHLD3.52HD/FM, 10/Pack",Cindy Schnelling,39846,-62.73,4.98,4.62,Northwest Territories,Computer Peripherals,0.64
359,8260,Heather Kirkland,40036,-147.36,65.99,8.99,Northwest Territories,Telephones and Communication,0.58
360,3390,Alan Barnes,40067,519.25,65.99,5.31,Northwest Territories,Telephones and Communication,0.57
361,"Global Deluxe Stacking Chair, Gray",Hunter Glantz,40132,149.83,50.98,14.19,Northwest Territories,Chairs & Chairmats,0.56
362,Bevis 36 x 72 Conference Tables,Hunter Glantz,40132,-219.38,124.49,51.94,Northwest Territories,Tables,0.63
363,"Avery Flip-Chart Easel Binder, Black",Hunter Glantz,40132,-86.20,22.38,15.1,Northwest Territories,Binders and Binder Accessories,0.38
364,"Howard Miller 16 Diameter Gallery Wall Clock",Julia West,40160,202.87,63.94,14.48,Northwest Territories,Office Furnishings,0.46
365,"ACCOHIDE® 3-Ring Binder, Blue, 1",Carlos Daly,40518,-12.16,4.13,5.04,Northwest Territories,Binders and Binder Accessories,0.38
366,"Global High-Back Leather Tilter, Burgundy",Barry French,40804,-1775.83,122.99,70.2,Northwest Territories,Chairs & Chairmats,0.74
367,"Wilson Jones Hanging View Binder, White, 1",Susan Vittorini,40902,-48.88,7.1,6.05,Northwest Territories,Binders and Binder Accessories,0.39
368,Boston 1730 StandUp Electric Pencil Sharpener,Carl Jackson,41063,-34.09,21.38,8.99,Northwest Territories,Pens & Art Supplies,0.59
369,Accessory31,Carl Jackson,41063,42.27,35.99,0.99,Northwest Territories,Telephones and Communication,0.35
370,Accessory8,Carl Jackson,41063,822.89,85.99,1.25,Northwest Territories,Telephones and Communication,0.39
371,Fellowes 17-key keypad for PS/2 interface,Alan Barnes,41153,-45.10,30.73,4,Northwest Territories,Computer Peripherals,0.75
372,Hanging Personal Folder File,Charlotte Melton,41184,-56.06,15.7,11.25,Northwest Territories,Storage & Organization,0.6
373,Ibico Covers for Plastic or Wire Binding Elements,Beth Thompson,41409,-18.25,11.5,7.19,Northwest Territories,Binders and Binder Accessories,0.4
374,Hoover Portapower™ Portable Vacuum,Bryan Mills,41696,-2088.68,4.48,49,Northwest Territories,Appliances,0.6
375,Fellowes Command Center 5-outlet power strip,Alan Barnes,42209,-12.82,67.84,0.99,Northwest Territories,Appliances,0.58
376,SAFCO Arco Folding Chair,Alan Barnes,42209,2795.36,276.2,24.49,Northwest Territories,Chairs & Chairmats,
377,Accessory12,Beth Paige,42561,298.48,85.99,2.5,Northwest Territories,Telephones and Communication,0.35
378,"Global Leather Highback Executive Chair with Pneumatic Height Adjustment, Black",Mike Pelletier,42564,2155.41,200.98,23.76,Northwest Territories,Chairs & Chairmats,0.58
379,3390,Delfina Latchford,42695,-10.30,65.99,5.31,Northwest Territories,Telephones and Communication,0.57
380,GBC DocuBind TL300 Electric Binding System,Susan Vittorini,42981,232.44,896.99,19.99,Northwest Territories,Binders and Binder Accessories,0.38
381,"GBC Prepunched Paper, 19-Hole, for Binding Systems, 24-lb",Dorothy Wardle,43109,-21.85,15.01,8.4,Northwest Territories,Binders and Binder Accessories,0.39
382,Microsoft Internet Keyboard,Dorothy Wardle,43109,-145.78,20.97,6.5,Northwest Territories,Computer Peripherals,0.78
383,TDK 4.7GB DVD-R,Dorothy Wardle,43109,-3.96,10.01,1.99,Northwest Territories,Computer Peripherals,0.41
384,Xerox 1977,Susan Vittorini,43203,-33.69,6.68,5.2,Northwest Territories,Paper,0.37
385,DAX Solid Wood Frames,Jamie Kunitz,43236,10.68,9.77,6.02,Northwest Territories,Office Furnishings,0.48
386,Honeywell Enviracaire® Portable Air Cleaner for up to 8 x 10 Room,Fred Wasserman,43267,171.26,76.72,19.95,Northwest Territories,Appliances,0.54
387,Belkin 8 Outlet SurgeMaster II Gold Surge Protector,Doug Bickford,43329,752.37,59.98,3.99,Northwest Territories,Appliances,0.57
388,8260,Fred Wasserman,43330,337.04,65.99,8.99,Northwest Territories,Telephones and Communication,0.58
389,"Recycled Interoffice Envelopes with String and Button Closure, 10 x 13",Susan Vittorini,43364,158.98,23.99,6.71,Northwest Territories,Envelopes,0.35
390,Multimedia Mailers,Doug Bickford,43392,2969.81,162.93,19.99,Northwest Territories,Envelopes,0.39
391,"White Business Envelopes with Contemporary Seam, Recycled White Business Envelopes",Claudia Miner,43781,240.41,10.94,1.39,Northwest Territories,Envelopes,0.35
392,"Avery Trapezoid Ring Binder, 3 Capacity, Black, 1040 sheets",Claudia Miner,43781,393.41,40.98,2.99,Northwest Territories,Binders and Binder Accessories,0.36
393,"DXL™ Angle-View Binders with Locking Rings, Black",Frank Price,44071,-43.75,5.99,4.92,Northwest Territories,Binders and Binder Accessories,0.38
394,8260,Frank Price,44071,83.84,65.99,8.99,Northwest Territories,Telephones and Communication,0.58
395,Newell® 3-Hole Punched Plastic Slotted Magazine Holders for Binders,Dorothy Wardle,44519,-144.76,4.57,5.42,Northwest Territories,Binders and Binder Accessories,0.37
396,Laser & Ink Jet Business Envelopes,Dorothy Wardle,44519,155.69,10.67,1.39,Northwest Territories,Envelopes,0.39
397,Okidata ML390 Turbo Dot Matrix Printers,Dorothy Wardle,44519,5386.32,442.14,14.7,Northwest Territories,Office Machines,0.56
398,"Eldon Regeneration Recycled Desk Accessories, Smoke",Allen Rosenblatt,44708,-37.39,1.74,4.08,Northwest Territories,Office Furnishings,0.53
399,Accessory36,Dorothy Wardle,44772,-232.99,55.99,5,Northwest Territories,Telephones and Communication,0.83
400,"Linden® 12 Wall Clock With Oak Frame",Julia West,44839,-246.30,33.98,19.99,Northwest Territories,Office Furnishings,0.55
401,2160i,Ralph Knight,45217,1864.66,200.99,4.2,Northwest Territories,Telephones and Communication,0.59
402,Global Deluxe High-Back Office Chair in Storm,Michelle Lonsdale,45440,-183.60,135.99,28.63,Northwest Territories,Chairs & Chairmats,0.76
403,"Howard Miller 16 Diameter Gallery Wall Clock",Charlotte Melton,45766,1026.07,63.94,14.48,Northwest Territories,Office Furnishings,0.46
404,Canon MP100DHII Printing Calculator,Charlotte Melton,45766,1765.48,140.99,13.99,Northwest Territories,Office Machines,0.37
405,Accessory21,Allen Rosenblatt,45861,319.10,20.99,0.99,Northwest Territories,Telephones and Communication,0.37
406,Verbatim DVD-R 4.7GB authoring disc,Neola Schneider,45957,162.83,39.24,1.99,Northwest Territories,Computer Peripherals,0.51
407,"Rediform Wirebound Phone Memo Message Book, 11 x 5-3/4",Neola Schneider,45957,-30.92,7.64,5.83,Northwest Territories,Paper,0.36
408,"C-Line Cubicle Keepers Polyproplyene Holder w/Velcro® Back, 8-1/2x11, 25/Bx",Joy Bell,46912,181.53,54.74,14.83,Northwest Territories,Office Furnishings,0.54
409,Avery 51,Monica Federle,46980,103.16,6.3,0.5,Northwest Territories,Labels,0.39
410,SANFORD Liquid Accent™ Tank-Style Highlighters,Jamie Kunitz,47460,-3.64,2.84,0.93,Northwest Territories,Pens & Art Supplies,0.54
411,Avery Poly Binder Pockets,Susan Vittorini,47462,-166.92,3.58,5.47,Northwest Territories,Binders and Binder Accessories,0.37
412,"Dixon My First Ticonderoga Pencil, #2",Susan Vittorini,47462,-1.22,5.85,2.27,Northwest Territories,Pens & Art Supplies,0.56
413,Acco® Hot Clips™ Clips to Go,Susan Vittorini,47462,21.62,3.29,1.35,Northwest Territories,Rubber Bands,0.4
414,Fiskars® Softgrip Scissors,Charles McCrossin,47620,20.27,10.98,3.37,Northwest Territories,"Scissors, Rulers and Trimmers",0.57
415,"Elite 5 Scissors",Cari Schnelling,47749,-188.53,8.45,7.77,Northwest Territories,"Scissors, Rulers and Trimmers",0.55
416,Eldon Wave Desk Accessories,Doug Bickford,47873,-17.38,5.89,5.57,Northwest Territories,Office Furnishings,0.41
417,Avery 478,Don Miller,47943,24.06,4.91,0.5,Northwest Territories,Labels,0.36
418,Boston 16701 Slimline Battery Pencil Sharpener,Don Miller,47943,63.46,15.94,5.45,Northwest Territories,Pens & Art Supplies,0.55
419,Xerox 1982,Fred Wasserman,48101,-39.92,22.84,16.87,Northwest Territories,Paper,0.39
420,"Soundgear Copyboard Conference Phone, Optional Battery",Bryan Mills,48295,4938.78,204.1,13.99,Northwest Territories,Office Machines,0.37
421,"Dot Matrix Printer Tape Reel Labels, White, 5000/Box",Carlos Daly,48839,-37.06,98.31,0.49,Northwest Territories,Labels,0.36
422,Euro Pro Shark Stick Mini Vacuum,Joy Bell,49154,-807.89,60.98,49,Northwest Territories,Appliances,0.59
423,Panasonic KX-P1150 Dot Matrix Printer,Claudia Miner,49921,-280.28,145.45,17.85,Northwest Territories,Office Machines,0.56
424,Recycled Eldon Regeneration Jumbo File,Claudia Miner,49921,-7.26,12.28,6.13,Northwest Territories,Storage & Organization,0.57
425,"Tenex Contemporary Contur Chairmats for Low and Medium Pile Carpet, Computer, 39 x 49",Beth Thompson,49952,630.28,107.53,5.81,Northwest Territories,Office Furnishings,0.65
426,Avery 498,Allen Rosenblatt,50117,14.49,2.89,0.5,Northwest Territories,Labels,0.38
427,Premium Transparent Presentation Covers by GBC,Beth Thompson,50278,-27.53,20.98,8.83,Northwest Territories,Binders and Binder Accessories,0.37
428,"Barricks 18 x 48 Non-Folding Utility Table with Bottom Storage Shelf",Beth Thompson,50278,-355.94,100.8,60,Northwest Territories,Tables,0.59
429,GBC VeloBinder Electric Binding Machine,Susan Vittorini,50374,1443.35,120.98,9.07,Northwest Territories,Binders and Binder Accessories,0.35
430,Brown Kraft Recycled Envelopes,Sylvia Foulston,50565,-138.82,16.98,12.39,Northwest Territories,Envelopes,0.35
431,"Acme® 8 Straight Scissors",Joy Bell,50688,27.86,12.98,3.14,Northwest Territories,"Scissors, Rulers and Trimmers",0.6
432,Bell Sonecor JB700 Caller ID,Becky Castell,50754,-58.34,7.99,5.03,Northwest Territories,Telephones and Communication,0.6
433,A1228,Carlos Daly,50914,2763.13,195.99,8.99,Northwest Territories,Telephones and Communication,0.58
434,"3M Polarizing Task Lamp with Clamp Arm, Light Gray",Cari Schnelling,51169,-192.92,136.98,24.49,Northwest Territories,Office Furnishings,0.59
435,8290,Jim Radford,51938,-488.31,125.99,5.63,Northwest Territories,Telephones and Communication,0.6
436,Hewlett-Packard Deskjet 5550 Color Inkjet Printer,Allen Rosenblatt,51970,-343.47,115.99,56.14,Northwest Territories,Office Machines,0.4
437,Fellowes Neat Ideas® Storage Cubes,Dorothy Badders,51971,-1129.96,32.48,35,Northwest Territories,Storage & Organization,0.81
438,"Lesro Round Back Collection Coffee Table, End Table",Dorothy Badders,51971,-803.52,182.55,69,Northwest Territories,Tables,0.72
439,Avery 492,Mike Pelletier,52193,10.51,2.88,0.5,Northwest Territories,Labels,0.39
440,Newell 343,Mike Pelletier,52193,6.04,2.94,0.96,Northwest Territories,Pens & Art Supplies,0.58
441,Recycled Eldon Regeneration Jumbo File,Doug Bickford,52321,-37.52,12.28,6.13,Northwest Territories,Storage & Organization,0.57
442,"SAFCO PlanMaster Heigh-Adjustable Drafting Table Base, 43w x 30d x 30-37h, Black",Doug Bickford,52321,5626.42,349.45,60,Northwest Territories,Tables,
443,Canon S750 Color Inkjet Printer,Susan Vittorini,52386,-188.58,120.97,26.3,Northwest Territories,Office Machines,0.38
444,Panasonic KP-310 Heavy-Duty Electric Pencil Sharpener,Andrew Gjertsen,52807,204.74,21.98,2.87,Northwest Territories,Pens & Art Supplies,0.55
445,"AT&T Black Trimline Phone, Model 210",Muhammed MacIntyre,52929,-90.14,15.99,9.4,Northwest Territories,Office Machines,0.49
446,Newell 318,Muhammed MacIntyre,52929,-6.53,2.78,1.25,Northwest Territories,Pens & Art Supplies,0.59
447,"Staples Pen Style Liquid Stix; Assorted (yellow, pink, green, blue, orange), 5/Pack",Muhammed MacIntyre,52929,7.34,6.47,1.22,Northwest Territories,Pens & Art Supplies,0.4
448,Staples Vinyl Coated Paper Clips,Muhammed MacIntyre,52929,19.68,3.93,0.99,Northwest Territories,Rubber Bands,0.39
449,"3M Polarizing Task Lamp with Clamp Arm, Light Gray",Jim Radford,52964,828.27,136.98,24.49,Northwest Territories,Office Furnishings,0.59
450,Avery 491,Bryan Davis,53156,56.44,4.13,0.99,Northwest Territories,Labels,0.39
451,Fellowes Black Plastic Comb Bindings,Anthony Johnson,53511,-243.24,5.81,8.49,Northwest Territories,Binders and Binder Accessories,0.39
452,"Eldon Expressions™ Desk Accessory, Wood Pencil Holder, Oak",Anthony Johnson,53511,-53.62,9.65,6.22,Northwest Territories,Office Furnishings,0.55
453,O'Sullivan 3-Shelf Heavy-Duty Bookcases,Doug Bickford,53797,-213.32,58.14,36.61,Northwest Territories,Bookcases,0.61
454,T18,Carlos Daly,53990,1411.03,110.99,2.5,Northwest Territories,Telephones and Communication,0.57
455,Sanyo 2.5 Cubic Foot Mid-Size Office Refrigerators,Don Miller,54083,258.01,279.81,23.19,Northwest Territories,Appliances,0.59
456,Honeywell Quietcare HEPA Air Cleaner,Don Jones,54274,328.00,78.65,13.99,Northwest Territories,Appliances,0.52
457,Staples Colored Bar Computer Paper,Chad Cunningham,54276,299.59,35.44,4.92,Northwest Territories,Paper,0.38
458,Boston 16765 Mini Stand Up Battery Pencil Sharpener,Ralph Arnett,54528,-85.91,11.66,8.99,Northwest Territories,Pens & Art Supplies,0.59
459,Staples Battery-Operated Desktop Pencil Sharpener,Ralph Arnett,54528,-6.38,10.48,2.89,Northwest Territories,Pens & Art Supplies,0.6
460,Eldon® 200 Class™ Desk Accessories,Nicole Hansen,54567,-61.59,6.28,5.41,Northwest Territories,Office Furnishings,0.53
461,"Memorex 80 Minute CD-R, 30/Pack",Fred Wasserman,54628,115.54,22.98,1.99,Northwest Territories,Computer Peripherals,0.46
462,"Global Leather and Oak Executive Chair, Black",Bryan Mills,55298,-165.60,300.98,64.73,Northwest Territories,Chairs & Chairmats,0.56
463,"Dual Level, Single-Width Filing Carts",Ralph Arnett,55363,542.16,155.06,7.07,Northwest Territories,Storage & Organization,0.59
464,"Fellowes Smart Design 104-Key Enhanced Keyboard, PS/2 Adapter, Platinum",Doug Bickford,55366,-204.65,55.94,6.55,Northwest Territories,Computer Peripherals,0.68
465,"Wilson Jones 1 Hanging DublLock® Ring Binders",Eugene Barchas,55715,16.65,5.28,2.99,Northwest Territories,Binders and Binder Accessories,0.37
466,"Master Giant Foot® Doorstop, Safety Yellow",Brad Eason,55875,39.29,7.59,4,Northwest Territories,Office Furnishings,0.42
467,"Perma STOR-ALL™ Hanging File Box, 13 1/8W x 12 1/4D x 10 1/2H",Brad Eason,55875,-104.96,5.98,4.69,Northwest Territories,Storage & Organization,0.68
468,Epson DFX-8500 Dot Matrix Printer,Dorothy Wardle,56453,-5572.39,2550.14,29.7,Northwest Territories,Office Machines,0.57
469,Xerox 194,Ralph Knight,57127,171.82,55.48,14.3,Northwest Territories,Paper,0.37
470,SouthWestern Bell FA970 Digital Answering Machine with Time/Day Stamp,Sylvia Foulston,57344,-71.03,28.99,8.59,Northwest Territories,Telephones and Communication,0.56
471,Avery 493,Neola Schneider,57509,101.13,4.91,0.5,Northwest Territories,Labels,0.36
472,"Bevis Round Bullnose 29 High Table Top",Neola Schneider,57509,-202.58,259.71,66.67,Northwest Territories,Tables,0.61
473,GBC Recycled Regency Composition Covers,Grant Carroll,57600,584.15,59.78,10.29,Northwest Territories,Binders and Binder Accessories,0.39
474,Avery 506,Grant Carroll,57600,85.81,4.13,0.5,Prince Edward Island,Labels,0.39
475,Xerox 197,Grant Carroll,57600,-8.42,30.98,17.08,Prince Edward Island,Paper,0.4
476,"Eldon® Expressions™ Wood Desk Accessories, Oak",Julia West,58055,-56.45,7.38,5.21,Prince Edward Island,Office Furnishings,0.56
477,Xerox 1935,Muhammed MacIntyre,58144,257.32,26.38,5.86,Prince Edward Island,Paper,0.39
478,Peel & Stick Add-On Corner Pockets,Susan Vittorini,58150,-119.62,2.16,6.05,Prince Edward Island,Binders and Binder Accessories,0.37
479,Eureka The Boss® Cordless Rechargeable Stick Vac,Sylvia Foulston,58340,278.12,50.98,13.66,Prince Edward Island,Appliances,0.58
480,Eldon® Wave Desk Accessories,Doug Bickford,58368,-4.43,2.08,5.33,Prince Edward Island,Office Furnishings,0.43
481,Xerox 1905,Doug Bickford,58368,-206.46,6.48,9.54,Prince Edward Island,Paper,0.37
482,Fellowes Bankers Box™ Staxonsteel® Drawer File/Stacking System,Doug Bickford,58368,-76.11,64.98,6.88,Prince Edward Island,Storage & Organization,0.73
483,"Executive Impressions 13 Clairmont Wall Clock",Dorothy Badders,58434,268.32,19.23,6.15,Prince Edward Island,Office Furnishings,0.44
484,"Global Leather and Oak Executive Chair, Black",Henry Goldwyn,58626,673.77,300.98,64.73,Prince Edward Island,Chairs & Chairmats,0.56
485,Global Troy™ Executive Leather Low-Back Tilter,Henry Goldwyn,58626,2608.72,500.98,26,Prince Edward Island,Chairs & Chairmats,0.6
486,"Verbatim DVD-RAM, 9.4GB, Rewritable, Type 1, DS, DataLife Plus",Henry Goldwyn,58626,171.59,45.19,1.99,Prince Edward Island,Computer Peripherals,0.55
487,Staples SlimLine Pencil Sharpener,Grant Carroll,58688,-41.87,11.97,5.81,Prince Edward Island,Pens & Art Supplies,0.6
488,Presstex Flexible Ring Binders,Chad Cunningham,59045,32.87,4.55,1.49,Prince Edward Island,Binders and Binder Accessories,0.35
489,"Memorex 4.7GB DVD+RW, 3/Pack",Beth Thompson,59047,19.20,28.48,1.99,Prince Edward Island,Computer Peripherals,0.4
490,Eldon Image Series Black Desk Accessories,Beth Thompson,59047,-93.93,4.14,6.6,Prince Edward Island,Office Furnishings,0.49
491,Avery 485,Andrew Gjertsen,59202,21.92,12.53,0.5,Prince Edward Island,Labels,0.38
492,"Dixon My First Ticonderoga Pencil, #2",Andrew Gjertsen,59202,7.45,5.85,2.27,Prince Edward Island,Pens & Art Supplies,0.56
493,Global Adaptabilities™ Conference Tables,Sylvia Foulston,59207,-945.56,280.98,81.98,Prince Edward Island,Tables,0.78
494,Kensington 7 Outlet MasterPiece Power Center,Michelle Lonsdale,59234,2109.21,177.98,0.99,Prince Edward Island,Appliances,0.56
495,"Global Deluxe Stacking Chair, Gray",Michelle Lonsdale,59234,11.46,50.98,14.19,Prince Edward Island,Chairs & Chairmats,0.56
496,Xerox 1885,Cari Schnelling,59395,367.12,48.04,7.23,Prince Edward Island,Paper,0.37
497,Avery 479,Henry Goldwyn,59558,37.73,2.61,0.5,Prince Edward Island,Labels,0.39
498,"AT&T Black Trimline Phone, Model 210",Edward Hooks,59585,-110.93,15.99,9.4,Prince Edward Island,Office Machines,0.49
499,"Fellowes Twister Kit, Gray/Clear, 3/pkg",Brendan Dodson,59651,-196.06,8.04,8.94,Prince Edward Island,Binders and Binder Accessories,0.4
500,Eldon Pizzaz™ Desk Accessories,Brendan Dodson,59651,-52.92,2.23,4.57,Prince Edward Island,Office Furnishings,0.41
501,GBC Binding covers,Harold Engle,645,89.45,12.95,4.98,Prince Edward Island,Binders and Binder Accessories,0.4
502,Hewlett-Packard Deskjet 5550 Color Inkjet Printer,Roy French,769,4.15,115.99,56.14,Prince Edward Island,Office Machines,0.4
503,Talkabout T8367,Helen Abelman,773,324.93,65.99,8.99,Prince Edward Island,Telephones and Communication,0.56
504,Logitech Access Keyboard,Guy Armstrong,1187,20.21,15.98,4,Prince Edward Island,Computer Peripherals,0.37
505,"Fellowes Strictly Business® Drawer File, Letter/Legal Size",Jennifer Braxton,2339,-120.45,140.85,19.99,Prince Edward Island,Storage & Organization,0.73
506,Newell 336,Giulietta Baptist,3521,28.71,4.28,0.94,Prince Edward Island,Pens & Art Supplies,0.56
507,"Conquest™ 14 Commercial Heavy-Duty Upright Vacuum, Collection System, Accessory Kit",Jack Lebron,4007,112.36,56.96,13.22,Prince Edward Island,Appliances,0.56
508,"Tennsco Snap-Together Open Shelving Units, Starter Sets and Add-On Units",Jack Lebron,4007,-232.24,279.48,35,Prince Edward Island,Storage & Organization,0.8
509,GBC DocuBind P100 Manual Binding Machine,Erica Bern,4416,2665.40,165.98,19.99,Prince Edward Island,Binders and Binder Accessories,0.4
510,Avery 497,Erica Bern,4454,21.42,3.08,0.5,Prince Edward Island,Labels,0.37
511,SAFCO Folding Chair Trolley,Helen Abelman,5153,1467.82,128.24,12.65,Prince Edward Island,Chairs & Chairmats,
512,"Manila Recycled Extra-Heavyweight Clasp Envelopes, 6 x 9",Guy Armstrong,5446,44.10,10.98,4.8,Prince Edward Island,Envelopes,0.36
513,"Verbatim DVD-RAM, 5.2GB, Rewritable, Type 1, DS",Helen Abelman,8131,191.29,29.89,1.99,Prince Edward Island,Computer Peripherals,0.5
514,Keytronic Designer 104- Key Black Keyboard,Christopher Schild,8994,-580.32,40.48,19.99,Prince Edward Island,Computer Peripherals,0.77
515,Accessory31,Roy French,9027,458.98,35.99,0.99,Prince Edward Island,Telephones and Communication,0.35
516,Avanti 4.4 Cu. Ft. Refrigerator,Roy French,9216,-86.68,180.98,55.24,Prince Edward Island,Appliances,0.57
517,Bush Mission Pointe Library,Jennifer Braxton,9537,-382.38,150.98,66.27,Prince Edward Island,Bookcases,0.65
518,"Acco Pressboard Covers with Storage Hooks, 14 7/8 x 11, Dark Blue",Jennifer Braxton,9537,-149.09,3.81,5.44,Prince Edward Island,Binders and Binder Accessories,0.36
519,Ibico Covers for Plastic or Wire Binding Elements,Joy Smith,9574,-68.98,11.5,7.19,Prince Edward Island,Binders and Binder Accessories,0.4
520,Boston KS Multi-Size Manual Pencil Sharpener,Evan Minnotte,10435,-14.31,22.99,8.99,Prince Edward Island,Pens & Art Supplies,0.57
521,"Hunt BOSTON® Vista® Battery-Operated Pencil Sharpener, Black",Evan Minnotte,10435,-162.24,11.66,7.95,Prince Edward Island,Pens & Art Supplies,0.58
522,Martin-Yale Premier Letter Opener,Jenna Caffey,10851,-175.13,12.88,4.59,Prince Edward Island,"Scissors, Rulers and Trimmers",0.82
523,Recycled Premium Regency Composition Covers,Harold Engle,10852,-27.26,15.28,10.91,Prince Edward Island,Binders and Binder Accessories,0.36
524,"Atlantic Metals Mobile 5-Shelf Bookcases, Custom Colors",Harold Engle,10852,3030.16,300.98,54.92,Prince Edward Island,Bookcases,0.55
525,i1000,Harold Engle,11269,354.96,65.99,5.99,Prince Edward Island,Telephones and Communication,0.58
526,Avery 493,Harold Engle,11269,112.35,4.91,0.5,Prince Edward Island,Labels,0.36
527,Fellowes Super Stor/Drawer®,Harold Engle,11269,-19.32,27.75,19.99,Prince Edward Island,Storage & Organization,0.67
528,"Rubbermaid ClusterMat Chairmats, Mat Size- 66 x 60, Lip 20 x 11 -90 Degree Angle",Hilary Holden,11362,569.57,110.98,13.99,Prince Edward Island,Office Furnishings,0.69
529,*Staples* Letter Opener,Hilary Holden,11362,-119.66,2.18,5,Prince Edward Island,"Scissors, Rulers and Trimmers",0.81
530,Canon PC1060 Personal Laser Copier,Hilary Holden,11362,-690.21,699.99,24.49,Prince Edward Island,Copiers and Fax,0.41
531,LX 677,Hilary Holden,11362,424.14,110.99,8.99,Prince Edward Island,Telephones and Communication,0.57
532,Avery Hi-Liter® Fluorescent Desk Style Markers,Christopher Schild,11968,26.09,3.38,0.85,Prince Edward Island,Pens & Art Supplies,0.48
533,"#10- 4 1/8 x 9 1/2 Recycled Envelopes",Harold Engle,12293,119.64,8.74,1.39,Prince Edward Island,Envelopes,0.38
534,Acco Suede Grain Vinyl Round Ring Binder,Greg Guthrie,12773,-4.61,2.78,1.49,Prince Edward Island,Binders and Binder Accessories,0.39
535,Eldon Image Series Black Desk Accessories,Greg Guthrie,12773,-49.60,4.14,6.6,Prince Edward Island,Office Furnishings,0.49
536,Xerox 213,Greg Guthrie,12773,-77.18,6.48,7.86,Prince Edward Island,Paper,0.37
537,Newell 342,Greg Guthrie,12773,-50.88,3.28,3.97,Prince Edward Island,Pens & Art Supplies,0.56
538,"Staples #10 Laser & Inkjet Envelopes, 4 1/8 x 9 1/2, 100/Box",Guy Armstrong,12934,186.64,9.78,1.39,Prince Edward Island,Envelopes,0.39
539,Newell 337,Guy Armstrong,12934,-66.35,3.28,3.97,Prince Edward Island,Pens & Art Supplies,0.56
540,GBC Binding covers,Joy Smith,13120,82.59,12.95,4.98,Prince Edward Island,Binders and Binder Accessories,0.4
541,GBC Standard Therm-A-Bind Covers,Joy Smith,13120,-17.37,24.92,12.98,Prince Edward Island,Binders and Binder Accessories,0.39
542,"Micro Innovations Micro Digital Wireless Keyboard and Mouse, Gray",Erica Bern,13604,1166.40,83.1,6.13,Prince Edward Island,Computer Peripherals,0.45
543,Eldon ClusterMat Chair Mat with Cordless Antistatic Protection,Erica Bern,13604,-1396.22,90.98,56.2,Prince Edward Island,Office Furnishings,0.74
544,Xerox 1985,Dan Reichenbach,13927,-21.41,6.48,5.16,Prince Edward Island,Paper,0.37
545,Zoom V.92 V.44 PCI Internal Controllerless FaxModem,Erica Bern,15044,167.37,39.99,10.25,Prince Edward Island,Computer Peripherals,0.55
546,"Global Leather and Oak Executive Chair, Black",Guy Armstrong,15139,636.20,300.98,64.73,Prince Edward Island,Chairs & Chairmats,0.56
547,"Tennsco Lockers, Sand",Guy Armstrong,15139,-1163.21,20.98,45,Prince Edward Island,Storage & Organization,0.61
548,Xerox 1920,Evan Minnotte,15463,-193.48,5.98,7.5,Prince Edward Island,Paper,0.4
549,Xerox 1928,Joy Smith,15618,-34.98,5.28,6.26,Prince Edward Island,Paper,0.4
550,Xerox 1939,Joy Smith,15618,26.27,18.97,9.54,Prince Edward Island,Paper,0.37
551,StarTAC 7760,Joy Smith,15618,-11.40,65.99,3.99,Prince Edward Island,Telephones and Communication,0.59
552,Magna Visual Magnetic Picture Hangers,Paul Gonzalez,16100,-115.54,4.82,5.72,Prince Edward Island,Office Furnishings,0.47
553,M3682,Filia McAdams,16320,176.87,125.99,8.08,Prince Edward Island,Telephones and Communication,0.57
554,Xerox 1978,Joy Smith,16419,-103.65,5.78,5.67,Prince Edward Island,Paper,0.36
555,"Sauder Forest Hills Library, Woodland Oak Finish",Greg Guthrie,17090,-443.78,140.98,36.09,Prince Edward Island,Bookcases,0.77
556,"Global High-Back Leather Tilter, Burgundy",Greg Guthrie,17090,-1086.43,122.99,70.2,Prince Edward Island,Chairs & Chairmats,0.74
557,"Wirebound Message Book, 4 per Page",Joy Smith,17315,64.01,5.43,0.95,Prince Edward Island,Paper,0.36
558,"Memorex 4.7GB DVD+RW, 3/Pack",Joy Smith,17376,425.08,28.48,1.99,Prince Edward Island,Computer Peripherals,0.4
559,Hoover WindTunnel™ Plus Canister Vacuum,Greg Guthrie,18210,2437.17,363.25,19.99,Prince Edward Island,Appliances,0.57
560,Newell 335,Greg Guthrie,18210,12.58,2.88,0.7,Prince Edward Island,Pens & Art Supplies,0.56
561,Zoom V.92 USB External Faxmodem,Jack Lebron,18273,-3.68,49.99,19.99,Prince Edward Island,Computer Peripherals,0.41
562,Telescoping Adjustable Floor Lamp,Joy Smith,18788,-19.33,19.99,11.17,Prince Edward Island,Office Furnishings,0.6
563,"Wilson Jones Ledger-Size, Piano-Hinge Binder, 2, Blue",Evan Minnotte,19042,54.90,40.98,7.47,Prince Edward Island,Binders and Binder Accessories,0.37
564,"Eldon Expressions Punched Metal & Wood Desk Accessories, Pewter & Cherry",Chuck Magee,19073,20.08,10.64,5.16,Prince Edward Island,Office Furnishings,0.57
565,Prang Drawing Pencil Set,Chuck Magee,19073,5.81,2.78,1.34,Prince Edward Island,Pens & Art Supplies,0.45
566,Xerox 1992,Filia McAdams,19365,-43.36,5.98,5.2,Prince Edward Island,Paper,0.36
567,TI 36X Solar Scientific Calculator,Jack Lebron,19617,270.69,23.99,6.3,Prince Edward Island,Office Machines,0.38
568,V 3600 Series,Jack Lebron,19617,-296.37,65.99,8.99,Prince Edward Island,Telephones and Communication,0.58
569,Sharp AL-1530CS Digital Copier,Jack Lebron,20033,-1011.32,499.99,24.49,Prince Edward Island,Copiers and Fax,0.36
570,Hon 4-Shelf Metal Bookcases,Harold Engle,21223,-144.43,100.98,26.22,Prince Edward Island,Bookcases,0.6
571,"Deflect-o EconoMat Nonstudded, No Bevel Mat",Harold Engle,21223,122.41,51.65,18.45,Prince Edward Island,Office Furnishings,0.65
572,Lock-Up Easel 'Spel-Binder',Jack Lebron,21378,391.60,28.53,1.49,Prince Edward Island,Binders and Binder Accessories,0.38
573,U.S. Robotics 56K Internet Call Modem,Jack Lebron,21378,26.94,99.99,19.99,Prince Edward Island,Computer Peripherals,0.5
574,Boston 1730 StandUp Electric Pencil Sharpener,Frank Atkinson,21542,-27.34,21.38,8.99,Prince Edward Island,Pens & Art Supplies,0.59
575,Bretford CR4500 Series Slim Rectangular Table,Frank Atkinson,21542,715.18,348.21,84.84,Prince Edward Island,Tables,0.66
576,Euro Pro Shark Stick Mini Vacuum,Jack Lebron,22469,-678.63,60.98,49,Prince Edward Island,Appliances,0.59
577,Hon 5100 Series Wood Tables,Jack Lebron,22469,40.32,290.98,69,Prince Edward Island,Tables,0.67
578,Belkin ErgoBoard™ Keyboard,Evan Minnotte,22656,-77.89,30.98,6.5,Prince Edward Island,Computer Peripherals,0.64
579,Riverleaf Stik-Withit® Designer Note Cubes®,Joy Smith,22695,161.13,10.06,2.06,Prince Edward Island,Paper,0.39
580,Coloredge Poster Frame,Dan Reichenbach,23076,122.21,14.2,5.3,Prince Edward Island,Office Furnishings,0.46
581,8860,Jack Lebron,24038,82.04,65.99,5.26,Prince Edward Island,Telephones and Communication,0.56
582,Xerox 1920,Frank Atkinson,24067,-79.35,5.98,7.5,Prince Edward Island,Paper,0.4
583,252,Frank Atkinson,24067,751.38,65.99,5.92,Prince Edward Island,Telephones and Communication,0.55
584,Sharp 1540cs Digital Laser Copier,Erica Bern,24388,-704.66,549.99,49,Prince Edward Island,Copiers and Fax,0.35
585,"Holmes Replacement Filter for HEPA Air Cleaner, Very Large Room, HEPA Filter",Jack Lebron,24451,-564.74,68.81,60,Prince Edward Island,Appliances,0.41
586,Wilson Jones Impact Binders,Filia McAdams,24806,-57.99,5.18,5.74,Prince Edward Island,Binders and Binder Accessories,0.36
587,GBC DocuBind 200 Manual Binding Machine,Jack Lebron,24965,580.15,420.98,19.99,Prince Edward Island,Binders and Binder Accessories,0.35
588,"Deflect-o SuperTray™ Unbreakable Stackable Tray, Letter, Black",Jack Lebron,24965,330.63,29.18,8.55,Prince Edward Island,Office Furnishings,0.42
589,Sanford Liquid Accent Highlighters,Giulietta Baptist,25154,13.84,6.68,1.5,Prince Edward Island,Pens & Art Supplies,0.48
590,Holmes Harmony HEPA Air Purifier for 17 x 20 Room,Joy Smith,25315,3506.24,225.04,11.79,Prince Edward Island,Appliances,0.42
591,SANFORD Liquid Accent™ Tank-Style Highlighters,Joy Smith,25315,4.34,2.84,0.93,Prince Edward Island,Pens & Art Supplies,0.54
592,Hon iLevel™ Computer Training Table,Joy Smith,25315,-1048.25,31.76,45.51,Prince Edward Island,Tables,0.65
593,"Eldon® 200 Class™ Desk Accessories, Burgundy",Greg Guthrie,25376,-31.83,6.28,5.29,Prince Edward Island,Office Furnishings,0.43
594,"80 Minute CD-R Spindle, 100/Pack - Staples",Carlos Soltero,26240,439.77,39.48,1.99,Prince Edward Island,Computer Peripherals,0.54
595,3M Hangers With Command Adhesive,Carlos Soltero,26240,12.00,3.7,1.61,Prince Edward Island,Office Furnishings,0.44
596,X-Rack™ File for Hanging Folders,Harold Engle,26791,-48.20,11.29,5.03,Prince Edward Island,Storage & Organization,0.59
597,688,Erica Bern,28836,2342.21,195.99,4.2,Prince Edward Island,Telephones and Communication,0.6
598,Ibico EB-19 Dual Function Manual Binding System,Erica Bern,28836,170.08,172.99,19.99,Prince Edward Island,Binders and Binder Accessories,0.39
599,"IBM Multi-Purpose Copy Paper, 8 1/2 x 11, Case",Hilary Holden,28995,73.19,30.98,5.76,Prince Edward Island,Paper,0.4
600,Southworth 25% Cotton Premium Laser Paper and Envelopes,Hilary Holden,28995,80.92,19.98,8.68,Prince Edward Island,Paper,0.37
601,Timeport L7089,Jack Lebron,29121,575.33,125.99,7.69,Prince Edward Island,Telephones and Communication,0.58
602,Safco Contoured Stacking Chairs,Filia McAdams,29319,1151.69,238.4,24.49,Prince Edward Island,Chairs & Chairmats,
603,Canon PC-428 Personal Copier,Filia McAdams,29319,983.55,199.99,24.49,Prince Edward Island,Copiers and Fax,0.46
604,Staples Standard Envelopes,Greg Guthrie,29382,78.96,5.68,1.39,Prince Edward Island,Envelopes,0.38
605,12-1/2 Diameter Round Wall Clock,Greg Guthrie,29382,35.09,19.98,10.49,Prince Edward Island,Office Furnishings,0.49
606,Lexmark Z55se Color Inkjet Printer,Harold Engle,29445,415.55,90.97,28,Prince Edward Island,Office Machines,0.38
607,Binder Clips by OIC,Philip Brown,29762,0.78,1.48,0.7,Prince Edward Island,Rubber Bands,0.37
608,Avanti 4.4 Cu. Ft. Refrigerator,Helen Abelman,30048,433.63,180.98,55.24,Prince Edward Island,Appliances,0.57
609,"Fellowes Smart Surge Ten-Outlet Protector, Platinum",Hilary Holden,30243,650.56,60.22,3.5,Prince Edward Island,Appliances,0.57
610,Canon PC-428 Personal Copier,Hilary Holden,30243,340.88,199.99,24.49,Prince Edward Island,Copiers and Fax,0.46
611,Aluminum Document Frame,Christopher Schild,30372,-7.39,12.22,2.85,Prince Edward Island,Office Furnishings,0.55
612,Wausau Papers Astrobrights® Colored Envelopes,Carlos Soltero,30499,5.66,5.98,2.5,Prince Edward Island,Envelopes,0.36
613,Newell 312,Carlos Soltero,30499,42.34,5.84,1.2,Prince Edward Island,Pens & Art Supplies,0.55
614,"Pressboard Covers with Storage Hooks, 9 1/2 x 11, Light Blue",Erica Bern,32199,-99.76,4.91,4.97,Prince Edward Island,Binders and Binder Accessories,0.38
615,Canon imageCLASS 2200 Advanced Copier,Erica Bern,32199,-3061.82,3499.99,24.49,Prince Edward Island,Copiers and Fax,0.37
616,Newell 312,Erica Bern,32199,-0.01,5.84,1.2,Prince Edward Island,Pens & Art Supplies,0.55
617,"Chromcraft Bull-Nose Wood 48 x 96 Rectangular Conference Tables",Erica Bern,32327,-1430.45,550.98,147.12,Prince Edward Island,Tables,0.8
618,"Verbatim DVD-RAM, 9.4GB, Rewritable, Type 1, DS, DataLife Plus",Joy Smith,32676,523.43,45.19,1.99,Prince Edward Island,Computer Peripherals,0.55
619,KF 788,Joy Smith,32835,-19.44,45.99,4.99,Prince Edward Island,Telephones and Communication,0.56
620,"Imation Neon Mac Format Diskettes, 10/Pack",Christopher Schild,32869,-82.83,8.12,2.83,Prince Edward Island,Computer Peripherals,0.77
621,"Deflect-o EconoMat Nonstudded, No Bevel Mat",Christopher Schild,32869,25.04,51.65,18.45,Prince Edward Island,Office Furnishings,0.65
622,Sanford Liquid Accent Highlighters,Christopher Schild,32869,-7.51,6.68,1.5,Prince Edward Island,Pens & Art Supplies,0.48
623,2180,Christopher Schild,32869,930.99,175.99,8.99,Prince Edward Island,Telephones and Communication,0.57
624,Sharp AL-1530CS Digital Copier,Evan Minnotte,33763,-234.79,499.99,24.49,Prince Edward Island,Copiers and Fax,0.36
625,"Executive Impressions 14 Contract Wall Clock",Christopher Schild,34048,-10.74,22.23,3.63,Prince Edward Island,Office Furnishings,0.52
626,*Staples* Highlighting Markers,Greg Guthrie,34275,26.66,4.84,0.71,Prince Edward Island,Pens & Art Supplies,0.52
627,Boston 19500 Mighty Mite Electric Pencil Sharpener,Harold Engle,34438,-30.72,20.15,8.99,Prince Edward Island,Pens & Art Supplies,0.58
628,Xerox 1995,Philip Brown,34880,-62.43,6.48,5.19,Prince Edward Island,Paper,0.37
629,Self-Adhesive Ring Binder Labels,Carlos Soltero,34978,-269.91,3.52,6.83,Prince Edward Island,Binders and Binder Accessories,0.38
630,Catalog Binders with Expanding Posts,Jennifer Braxton,35141,469.28,67.28,19.99,Prince Edward Island,Binders and Binder Accessories,0.4
631,*Staples* Packaging Labels,Dan Reichenbach,35300,7.15,2.89,0.49,Prince Edward Island,Labels,0.38
632,"Deflect-o EconoMat Studded, No Bevel Mat for Low Pile Carpeting",Dan Reichenbach,35300,126.03,41.32,8.66,Prince Edward Island,Office Furnishings,0.76
633,"Recycled Desk Saver Line While You Were Out Book, 5 1/2 X 4",Dan Reichenbach,35300,29.62,8.95,2.01,Prince Edward Island,Paper,0.39
634,9-3/4 Diameter Round Wall Clock,Carlos Soltero,35558,-22.12,13.79,8.78,Prince Edward Island,Office Furnishings,0.43
635,Logitech Cordless Elite Duo,Carlos Soltero,36293,250.47,100.98,7.18,Prince Edward Island,Computer Peripherals,0.4
636,Xerox 220,Carlos Soltero,36293,-94.79,6.48,7.49,Prince Edward Island,Paper,0.37
637,Logitech Cordless Elite Duo,Giulietta Baptist,36516,51.30,100.98,7.18,Prince Edward Island,Computer Peripherals,0.4
638,Canon Image Class D660 Copier,Jack Lebron,36677,-734.33,599.99,24.49,Prince Edward Island,Copiers and Fax,0.44
639,12 Colored Short Pencils,Guy Armstrong,37185,-13.27,2.6,2.4,Prince Edward Island,Pens & Art Supplies,0.58
640,Avery Legal 4-Ring Binder,Hilary Holden,37888,274.90,20.98,1.49,Prince Edward Island,Binders and Binder Accessories,0.35
641,Hoover® Commercial Lightweight Upright Vacuum,Jack Lebron,38310,-141.76,3.48,49,Prince Edward Island,Appliances,0.59
642,Colored Envelopes,Erica Bern,40327,-20.27,3.69,2.5,Prince Edward Island,Envelopes,0.39
643,Xerox 1953,Erica Bern,40327,-123.87,4.28,5.74,Prince Edward Island,Paper,0.4
644,GBC DocuBind 200 Manual Binding Machine,Harold Engle,40480,3049.45,420.98,19.99,Prince Edward Island,Binders and Binder Accessories,0.35
645,DAX Natural Wood-Tone Poster Frame,Harold Engle,40480,221.81,26.48,6.93,Prince Edward Island,Office Furnishings,0.49
646,Staples Standard Envelopes,Jim Sink,40800,26.11,5.68,1.39,Prince Edward Island,Envelopes,0.38
647,"GBC Prepunched Paper, 19-Hole, for Binding Systems, 24-lb",Jennifer Braxton,40835,-8.08,15.01,8.4,Prince Edward Island,Binders and Binder Accessories,0.39
648,Keytronic Designer 104- Key Black Keyboard,Jennifer Braxton,40835,-326.97,40.48,19.99,Prince Edward Island,Computer Peripherals,0.77
649,Recycled Eldon Regeneration Jumbo File,Jennifer Braxton,40835,-6.68,12.28,6.13,Prince Edward Island,Storage & Organization,0.57
650,GBC Standard Plastic Binding Systems Combs,Joy Smith,40871,-5.53,8.85,5.6,Prince Edward Island,Binders and Binder Accessories,0.36
651,Office Star Flex Back Scooter Chair with White Frame,Joy Smith,40871,-157.63,110.98,30,Prince Edward Island,Chairs & Chairmats,0.71
652,Xerox 1941,Harold Engle,41570,1037.55,104.85,4.65,Prince Edward Island,Paper,0.37
653,"Global Deluxe Stacking Chair, Gray",Philip Brown,41991,133.30,50.98,14.19,Prince Edward Island,Chairs & Chairmats,0.56
654,DAX Clear Channel Poster Frame,Philip Brown,41991,68.44,14.58,7.4,Prince Edward Island,Office Furnishings,0.48
655,Tenex B1-RE Series Chair Mats for Low Pile Carpets,Philip Brown,41991,256.66,45.98,4.8,Prince Edward Island,Office Furnishings,0.68
656,Belkin 105-Key Black Keyboard,Giulietta Baptist,42400,11.55,19.98,4,Prince Edward Island,Computer Peripherals,0.68
657,Micro Innovations 104 Keyboard,Giulietta Baptist,42400,-168.95,10.97,6.5,Prince Edward Island,Computer Peripherals,0.64
658,GBC Imprintable Covers,Paul Gonzalez,42754,32.19,10.98,5.14,Prince Edward Island,Binders and Binder Accessories,0.36
659,"GBC Laser Imprintable Binding System Covers, Desert Sand",Logan Haushalter,42918,30.48,14.27,7.27,Prince Edward Island,Binders and Binder Accessories,0.38
660,"Sharp EL501VB Scientific Calculator, Battery Operated, 10-Digit Display, Hard Case",Logan Haushalter,42918,-54.58,9.49,5.76,Prince Edward Island,Office Machines,0.39
661,Hon Multipurpose Stacking Arm Chairs,Filia McAdams,42944,1061.61,216.6,64.2,Prince Edward Island,Chairs & Chairmats,0.59
662,"Executive Impressions 14",Carlos Soltero,44037,326.43,22.23,5.08,Prince Edward Island,Office Furnishings,0.41
663,Accessory2,Carlos Soltero,44037,557.60,55.99,1.25,Prince Edward Island,Telephones and Communication,0.55
664,"Verbatim DVD-RAM, 5.2GB, Rewritable, Type 1, DS",Erica Bern,44387,475.26,29.89,1.99,Prince Edward Island,Computer Peripherals,0.5
665,Southworth 25% Cotton Antique Laid Paper & Envelopes,Erica Bern,44387,-6.71,8.34,4.82,Prince Edward Island,Paper,0.4
666,Bevis 36 x 72 Conference Tables,Greg Guthrie,44576,-189.35,124.49,51.94,Prince Edward Island,Tables,0.63
667,Xerox 1936,Dan Reichenbach,45601,267.64,19.98,5.97,Prince Edward Island,Paper,0.38
668,"Eldon® 400 Class™ Desk Accessories, Black Carbon",Jim Sink,45606,-124.25,8.75,8.54,Prince Edward Island,Office Furnishings,0.43
669,"Dixon My First Ticonderoga Pencil, #2",Jim Sink,45606,-8.38,5.85,2.27,Prince Edward Island,Pens & Art Supplies,0.56
670,Durable Pressboard Binders,Carlos Soltero,46119,15.27,3.8,1.49,Prince Edward Island,Binders and Binder Accessories,0.38
671,"Adams Telephone Message Book w/Frequently-Called Numbers Space, 400 Messages per Book",Carlos Soltero,46119,57.31,7.98,1.25,Prince Edward Island,Paper,0.35
672,Bretford “Just In Time” Height-Adjustable Multi-Task Work Tables,Carlos Soltero,46119,-575.35,417.4,75.23,Prince Edward Island,Tables,0.79
673,"Array® Parchment Paper, Assorted Colors",Chuck Magee,46756,-22.45,7.28,11.15,Prince Edward Island,Paper,0.37
674,Avery Durable Poly Binders,Philip Brown,47714,-125.36,5.53,6.98,Prince Edward Island,Binders and Binder Accessories,0.39
675,Dana Swing-Arm Lamps,Hilary Holden,47846,-9.45,10.68,13.04,Prince Edward Island,Office Furnishings,0.6
676,"Rubbermaid ClusterMat Chairmats, Mat Size- 66 x 60, Lip 20 x 11 -90 Degree Angle",Hilary Holden,47846,631.99,110.98,13.99,Prince Edward Island,Office Furnishings,0.69
677,"Tenex 46 x 60 Computer Anti-Static Chairmat, Rectangular Shaped",Hilary Holden,47846,1581.93,105.98,13.99,Prince Edward Island,Office Furnishings,0.65
678,HP Office Paper (20Lb. and 87 Bright),Hilary Holden,47846,-120.08,6.68,6.93,Prince Edward Island,Paper,0.37
679,Bionaire Personal Warm Mist Humidifier/Vaporizer,Greg Guthrie,47876,58.08,46.89,5.1,Prince Edward Island,Appliances,0.46
680,270c,Jennifer Braxton,48067,695.06,125.99,3,Prince Edward Island,Telephones and Communication,0.59
681,T28 WORLD,Jennifer Braxton,48067,630.70,195.99,8.99,Prince Edward Island,Telephones and Communication,0.6
682,"#10-4 1/8 x 9 1/2 Premium Diagonal Seam Envelopes",Erica Bern,48199,279.74,15.74,1.39,Prince Edward Island,Envelopes,0.4
683,CF 888,Jim Sink,49029,2549.40,195.99,3.99,Prince Edward Island,Telephones and Communication,0.59
684,GBC Standard Therm-A-Bind Covers,Noah Childs,49216,-45.82,24.92,12.98,Prince Edward Island,Binders and Binder Accessories,0.39
685,Epson LQ-570e Dot Matrix Printer,Noah Childs,49216,-172.48,270.97,28.06,Manitoba,Office Machines,0.56
686,Staples Premium Bright 1-Part Blank Computer Paper,Noah Childs,49216,30.63,12.28,6.35,Manitoba,Paper,0.38
687,Okidata ML390 Turbo Dot Matrix Printers,Evan Minnotte,49990,501.51,442.14,14.7,Manitoba,Office Machines,0.56
688,"Hon Metal Bookcases, Black",Guy Armstrong,50081,-88.75,70.98,26.74,Manitoba,Bookcases,0.6
689,"24 Capacity Maxi Data Binder Racks, Pearl",Guy Armstrong,50404,905.57,210.55,9.99,Manitoba,Storage & Organization,0.6
690,"Lesro Round Back Collection Coffee Table, End Table",Guy Armstrong,50404,-367.00,182.55,69,Manitoba,Tables,0.72
691,PC Concepts 116 Key Quantum 3000 Keyboard,Chuck Magee,50784,-130.88,32.98,5.5,Manitoba,Computer Peripherals,0.75
692,"Wilson Jones Ledger-Size, Piano-Hinge Binder, 2, Blue",Greg Guthrie,50850,578.14,40.98,7.47,Manitoba,Binders and Binder Accessories,0.37
693,Bretford “Just In Time” Height-Adjustable Multi-Task Work Tables,Greg Guthrie,50850,-634.87,417.4,75.23,Manitoba,Tables,0.79
694,Accessory17,Carlos Soltero,51075,-160.68,35.99,5,Manitoba,Telephones and Communication,0.82
695,Telescoping Adjustable Floor Lamp,Greg Guthrie,51461,-97.54,19.99,11.17,Manitoba,Office Furnishings,0.6
696,Xerox 1898,Greg Guthrie,51558,-87.27,6.68,6.92,Manitoba,Paper,0.37
697,"Barricks Non-Folding Utility Table with Steel Legs, Laminate Tops",Greg Guthrie,51558,85.29,85.29,60,Manitoba,Tables,0.56
698,ACCOHIDE® Binder by Acco,Carlos Soltero,52130,-39.96,4.13,5.34,Manitoba,Binders and Binder Accessories,0.38
699,Eldon Executive Woodline II Cherry Finish Desk Accessories,Carlos Soltero,52130,-4.01,40.89,18.98,Manitoba,Office Furnishings,0.57
700,Belkin 8 Outlet Surge Protector,Greg Guthrie,52482,163.78,40.98,5.33,Manitoba,Appliances,0.57
701,"Executive Impressions 14 Contract Wall Clock",Greg Guthrie,52482,217.06,22.23,3.63,Manitoba,Office Furnishings,0.52
702,"Holmes Replacement Filter for HEPA Air Cleaner, Large Room",Christopher Schild,53410,-253.11,14.81,13.32,Manitoba,Appliances,0.43
703,Bevis Steel Folding Chairs,Joy Smith,53477,-1207.18,95.95,74.35,Manitoba,Chairs & Chairmats,0.57
704,"Global Leather and Oak Executive Chair, Black",Joy Smith,53477,1261.44,300.98,64.73,Manitoba,Chairs & Chairmats,0.56
705,"Snap-A-Way® Black Print Carbonless Ruled Speed Letter, Triplicate",Joy Smith,53477,536.87,37.94,5.08,Manitoba,Paper,0.38
706,Fellowes Super Stor/Drawer® Files,Joy Smith,53477,610.90,161.55,19.99,Manitoba,Storage & Organization,0.66
707,Logitech Cordless Navigator Duo,Joy Smith,53508,149.64,80.98,7.18,Manitoba,Computer Peripherals,0.48
708,Sharp EL500L Fraction Calculator,Joy Smith,53508,-32.42,13.99,7.51,Manitoba,Office Machines,0.39
709,White GlueTop Scratch Pads,Joy Smith,53508,1.06,15.04,1.97,Manitoba,Paper,0.39
710,"Fellowes Strictly Business® Drawer File, Letter/Legal Size",Guy Armstrong,53703,-34.79,140.85,19.99,Manitoba,Storage & Organization,0.73
711,"Eureka Sanitaire ® Multi-Pro Heavy-Duty Upright, Disposable Bags",Brian Moss,54115,-80.05,4.37,5.15,Manitoba,Appliances,0.59
712,Cardinal Holdit Business Card Pockets,Brian Moss,54115,-89.42,4.98,4.95,Manitoba,Binders and Binder Accessories,0.37
713,Accessory36,Logan Haushalter,54437,-311.05,55.99,5,Manitoba,Telephones and Communication,0.83
714,T193,Guy Armstrong,54501,481.70,65.99,4.99,Manitoba,Telephones and Communication,0.57
715,Sharp EL500L Fraction Calculator,Guy Armstrong,54501,-33.03,13.99,7.51,Manitoba,Office Machines,0.39
716,Tennsco Commercial Shelving,Guy Armstrong,54501,-1195.29,20.34,35,Manitoba,Storage & Organization,0.84
717,T39m,Christopher Schild,54753,1380.32,155.99,3.9,Manitoba,Telephones and Communication,0.55
718,Tennsco Industrial Shelving,Jim Sink,55138,-628.38,48.91,35,Manitoba,Storage & Organization,0.83
719,Office Star Flex Back Scooter Chair with Aluminum Finish Frame,Carlos Soltero,55271,-210.14,100.89,42,Manitoba,Chairs & Chairmats,0.61
720,Colored Envelopes,Jennifer Braxton,55331,-8.24,3.69,2.5,Manitoba,Envelopes,0.39
721,Accessory13,Brian Moss,55618,479.95,35.99,1.25,Manitoba,Telephones and Communication,0.57
722,Xerox 197,Harold Engle,56645,65.82,30.98,17.08,Manitoba,Paper,0.4
723,Bretford CR4500 Series Slim Rectangular Table,Harold Engle,56645,3277.57,348.21,40.19,Manitoba,Tables,0.62
724,Xerox 1976,Carlos Soltero,56803,-103.27,6.48,5.9,Manitoba,Paper,0.37
725,Hon 2090 “Pillow Soft” Series Mid Back Swivel/Tilt Chairs,Hilary Holden,57159,-635.65,280.98,57,Manitoba,Chairs & Chairmats,0.78
726,Hammermill Color Copier Paper (28Lb. and 96 Bright),Hilary Holden,57159,-214.39,9.99,11.59,Manitoba,Paper,0.4
727,"GBC Prepunched Paper, 19-Hole, for Binding Systems, 24-lb",Logan Haushalter,57507,-19.68,15.01,8.4,Manitoba,Binders and Binder Accessories,0.39
728,"Acme Design Line 8 Stainless Steel Bent Scissors w/Champagne Handles, 3-1/8 Cut",Guy Armstrong,57922,-287.28,6.84,8.37,Manitoba,"Scissors, Rulers and Trimmers",0.58
729,Serrated Blade or Curved Handle Hand Letter Openers,Erica Bern,58117,-62.84,3.14,1.92,Manitoba,"Scissors, Rulers and Trimmers",0.84
730,"GE 48 Fluorescent Tube, Cool White Energy Saver, 34 Watts, 30/Box",Logan Haushalter,58278,2093.70,99.23,8.99,Manitoba,Office Furnishings,0.35
731,Accessory4,Logan Haushalter,58278,-434.56,85.99,0.99,Manitoba,Telephones and Communication,0.85
732,Hon GuestStacker Chair,Harold Engle,58502,1009.38,226.67,28.16,Manitoba,Chairs & Chairmats,0.59
733,Belkin ErgoBoard™ Keyboard,Christopher Schild,58788,43.72,30.98,6.5,Manitoba,Computer Peripherals,0.64
734,"TOPS Money Receipt Book, Consecutively Numbered in Red,",Helen Abelman,58947,102.58,8.01,2.87,Manitoba,Paper,0.4
735,Xerox 1989,Helen Abelman,58947,-67.79,4.98,5.02,Manitoba,Paper,0.38
736,"GE 4 Foot Flourescent Tube, 40 Watt",Jack Lebron,59074,70.80,14.98,8.99,British Columbia,Office Furnishings,0.39
737,"Bush Westfield Collection Bookcases, Fully Assembled",Jack Lebron,59233,-160.46,100.98,35.84,British Columbia,Bookcases,0.62
738,Nu-Dell Leatherette Frames,Jack Lebron,59233,7.69,14.34,5,British Columbia,Office Furnishings,0.49
739,"Micro Innovations Micro Digital Wireless Keyboard and Mouse, Gray",Giulietta Baptist,59425,717.12,83.1,6.13,British Columbia,Computer Peripherals,0.45
740,"Snap-A-Way® Black Print Carbonless Ruled Speed Letter, Triplicate",Giulietta Baptist,59425,741.27,37.94,5.08,British Columbia,Paper,0.38
741,Xerox 1994,Jim Sink,59750,-66.05,6.48,5.74,British Columbia,Paper,0.37
742,Dixon Ticonderoga Core-Lock Colored Pencils,Julie Creighton,35,60.72,9.11,2.25,British Columbia,Pens & Art Supplies,0.52
743,CF 688,Julie Creighton,35,48.99,155.99,8.99,British Columbia,Telephones and Communication,0.58
744,Fellowes Staxonsteel® Drawer Files,Sanjit Chand,294,489.02,193.17,19.99,British Columbia,Storage & Organization,0.71
745,Panasonic KP-350BK Electric Pencil Sharpener with Auto Stop,Matt Collins,450,109.33,34.58,8.99,British Columbia,Pens & Art Supplies,0.56
746,Hanging Personal Folder File,Matt Collins,450,-211.13,15.7,11.25,British Columbia,Storage & Organization,0.6
747,"Memorex 4.7GB DVD+RW, 3/Pack",Matt Collins,1028,-28.46,28.48,1.99,British Columbia,Computer Peripherals,0.4
748,3285,Matt Collins,1028,-60.39,205.99,5.99,British Columbia,Telephones and Communication,0.59
749,"Wirebound Message Books, Four 2 3/4 x 5 Forms per Page, 600 Sets per Book",Justin Knight,1314,-7.61,9.27,4.39,British Columbia,Paper,0.38
750,Office Star - Task Chair with Contemporary Loop Arms,Rob Haberlin,2279,205.83,90.98,30,British Columbia,Chairs & Chairmats,0.61
751,Acco Perma® 3000 Stacking Storage Drawers,Rob Haberlin,2279,52.53,20.98,5.42,British Columbia,Storage & Organization,0.66
752,"80 Minute CD-R Spindle, 100/Pack - Staples",Rob Haberlin,2465,271.87,39.48,1.99,British Columbia,Computer Peripherals,0.54
753,Avery 479,Rob Haberlin,2530,4.58,2.61,0.5,British Columbia,Labels,0.39
754,Fellowes Bankers Box™ Staxonsteel® Drawer File/Stacking System,Rob Haberlin,2883,177.66,64.98,6.88,British Columbia,Storage & Organization,0.73
755,"Imation Printable White 80 Minute CD-R Spindle, 50/Pack",Christina Vanderzanden,3362,734.75,40.98,1.99,British Columbia,Computer Peripherals,0.44
756,Eldon® Gobal File Keepers,Christina Vanderzanden,3362,-109.10,15.14,4.53,British Columbia,Storage & Organization,0.81
757,Kensington 7 Outlet MasterPiece® HOMEOFFICE Power Control Center,Matt Collins,5318,195.16,131.12,0.99,British Columbia,Appliances,0.55
758,2160i,Matt Collins,5318,1196.37,200.99,4.2,British Columbia,Telephones and Communication,0.59
759,Sharp AL-1530CS Digital Copier,Sanjit Chand,5988,-379.29,499.99,24.49,British Columbia,Copiers and Fax,0.36
760,"Seth Thomas 13 1/2 Wall Clock",Matt Collins,6115,78.86,17.78,5.03,British Columbia,Office Furnishings,0.54
761,"Tenex Carpeted, Granite-Look or Clear Contemporary Contour Shape Chair Mats",Justin Knight,6337,-912.08,70.71,37.58,British Columbia,Office Furnishings,0.78
762,Bretford Rectangular Conference Table Tops,Justin Knight,6337,-261.61,376.13,85.63,British Columbia,Tables,0.74
763,Wirebound Voice Message Log Book,Rob Haberlin,6434,14.49,4.76,0.88,British Columbia,Paper,0.39
764,"80 Minute CD-R Spindle, 100/Pack - Staples",Lena Cacioppo,7136,88.72,39.48,1.99,British Columbia,Computer Peripherals,0.54
765,Avery 493,Lena Cacioppo,7136,17.05,4.91,0.5,British Columbia,Labels,0.36
766,O'Sullivan Manor Hill 2-Door Library in Brianna Oak,Kimberly Carter,7489,552.97,180.98,23.58,British Columbia,Bookcases,0.74
767,Novimex Swivel Fabric Task Chair,Gene Hale,7968,-270.00,150.98,30,British Columbia,Chairs & Chairmats,0.74
768,"Imation Primaris 3.5 2HD Unformatted Diskettes, 10/Pack",Christina Vanderzanden,8227,-43.21,4.77,2.39,British Columbia,Computer Peripherals,0.72
769,Project Tote Personal File,Matt Collins,9123,-108.28,14.03,9.37,British Columbia,Storage & Organization,0.56
770,3M Organizer Strips,Sally Knutson,9792,-73.14,5.4,7.78,British Columbia,Binders and Binder Accessories,0.37
771,"Imation 3.5 DS-HD Macintosh Formatted Diskettes, 10/Pack",Kimberly Carter,9860,-73.66,7.28,3.52,British Columbia,Computer Peripherals,0.68
772,"Sanford Colorific Colored Pencils, 12/Box",Christina Vanderzanden,10310,9.59,2.88,1.01,British Columbia,Pens & Art Supplies,0.55
773,R380,Christina Vanderzanden,10310,-655.42,195.99,3.99,British Columbia,Telephones and Communication,0.58
774,Xerox 1899,Kimberly Carter,10369,-12.38,5.78,4.96,British Columbia,Paper,0.36
775,"Imation IBM Formatted Diskettes, 100/Pack",Kimberly Carter,10369,-95.54,28.48,8.99,British Columbia,Computer Peripherals,0.7
776,Barrel Sharpener,Rob Haberlin,10692,-69.91,3.57,4.17,British Columbia,Pens & Art Supplies,0.59
777,2160i,Rob Haberlin,10692,2369.84,200.99,4.2,British Columbia,Telephones and Communication,0.59
778,A1228,Rob Haberlin,10692,-457.16,195.99,8.99,British Columbia,Telephones and Communication,0.58
779,"Gould Plastics 9-Pocket Panel Bin, 18-3/8w x 5-1/4d x 20-1/2h, Black",Justin Knight,11553,-517.17,52.99,19.99,British Columbia,Storage & Organization,0.81
780,"Bush Westfield Collection Bookcases, Dark Cherry Finish, Fully Assembled",Justin Knight,11553,-429.86,100.98,57.38,British Columbia,Bookcases,0.78
781,Accessory34,Justin Knight,11553,365.42,85.99,0.99,British Columbia,Telephones and Communication,0.55
782,Bagged Rubber Bands,Christina Vanderzanden,11776,-14.10,1.26,0.7,British Columbia,Rubber Bands,0.81
783,Hammermill CopyPlus Copy Paper (20Lb. and 84 Bright),Marina Lichtenstein,11782,-63.72,4.98,4.75,British Columbia,Paper,0.36
784,"Panasonic All Digital Answering System with Caller ID*, KX-TM150B",Marina Lichtenstein,11782,14.35,66.99,13.99,British Columbia,Telephones and Communication,0.6
785,Wilson Jones® Four-Pocket Poly Binders,Justin Knight,12199,-10.73,6.54,5.27,British Columbia,Binders and Binder Accessories,0.36
786,"Dual Level, Single-Width Filing Carts",Justin Knight,12199,3051.62,155.06,7.07,British Columbia,Storage & Organization,0.59
787,Economy Binders,Gene Hale,14275,-7.73,2.08,1.49,British Columbia,Binders and Binder Accessories,0.36
788,Office Star - Mid Back Dual function Ergonomic High Back Chair with 2-Way Adjustable Arms,Gene Hale,14275,-187.75,160.98,30,British Columbia,Chairs & Chairmats,0.62
789,X-Rack™ File for Hanging Folders,Gene Hale,14535,-33.82,11.29,5.03,British Columbia,Storage & Organization,0.59
790,"Verbatim DVD-RAM, 5.2GB, Rewritable, Type 1, DS",Rob Haberlin,15329,319.52,29.89,1.99,British Columbia,Computer Peripherals,0.5
791,Newell 323,Gene Hale,15621,-13.95,1.68,1.57,British Columbia,Pens & Art Supplies,0.59
792,Eldon Portable Mobile Manager,Gene Hale,15621,-136.20,28.28,13.99,British Columbia,Storage & Organization,0.58
793,Avery Binder Labels,Michelle Arnett,17826,-88.61,3.89,7.01,British Columbia,Binders and Binder Accessories,0.37
794,Eldon Jumbo ProFile™ Portable File Boxes Graphite/Black,Sally Knutson,17926,-70.04,15.31,8.78,British Columbia,Storage & Organization,0.57
795,"Master Giant Foot® Doorstop, Safety Yellow",Rob Haberlin,18247,27.22,7.59,4,British Columbia,Office Furnishings,0.42
796,Newell 315,Justin Knight,18471,46.41,5.98,0.96,British Columbia,Pens & Art Supplies,0.6
797,Kleencut® Forged Office Shears by Acme United Corporation,Justin Knight,18471,-8.02,2.08,2.56,British Columbia,"Scissors, Rulers and Trimmers",0.55
798,Xerox 1983,Justin Knight,18471,-47.12,5.98,5.46,British Columbia,Paper,0.36
799,T61,Lena Cacioppo,19813,218.73,45.99,2.5,British Columbia,Telephones and Communication,0.56
800,Avery Poly Binder Pockets,Seth Vernon,20322,-183.36,3.58,5.47,British Columbia,Binders and Binder Accessories,0.37
801,"Bush Westfield Collection Bookcases, Fully Assembled",Seth Vernon,20322,-129.53,100.98,35.84,British Columbia,Bookcases,0.62
802,Xerox 196,Seth Vernon,20322,-72.28,5.78,7.96,British Columbia,Paper,0.36
803,Nu-Dell Leatherette Frames,Gene Hale,20422,115.21,14.34,5,British Columbia,Office Furnishings,0.49
804,Colored Envelopes,Luke Weiss,20448,6.84,3.69,2.5,British Columbia,Envelopes,0.39
805,"Pressboard Covers with Storage Hooks, 9 1/2 x 11, Light Blue",Justin Knight,21892,-18.34,4.91,4.97,British Columbia,Binders and Binder Accessories,0.38
806,Eldon Simplefile® Box Office®,Rob Haberlin,22980,-27.92,12.44,6.27,British Columbia,Storage & Organization,0.57
807,6190,Julie Creighton,23907,-164.46,65.99,2.5,British Columbia,Telephones and Communication,0.55
808,Panasonic KX-P3200 Dot Matrix Printer,Sanjit Chand,24064,935.80,297.64,14.7,British Columbia,Office Machines,0.57
809,Wilson Jones DublLock® D-Ring Binders,Justin Knight,24132,-4.49,6.75,2.99,British Columbia,Binders and Binder Accessories,0.35
810,"Wilson Jones Hanging View Binder, White, 1",Justin Knight,24132,-101.25,7.1,6.05,British Columbia,Binders and Binder Accessories,0.39
811,"Fellowes Basic 104-Key Keyboard, Platinum",Justin Knight,24132,-1.88,20.95,4,British Columbia,Computer Peripherals,0.6
812,Ibico Recycled Linen-Style Covers,Justin Knight,24132,339.75,39.06,10.55,British Columbia,Binders and Binder Accessories,0.37
813,Self-Adhesive Ring Binder Labels,Justin Knight,24132,-57.75,3.52,6.83,British Columbia,Binders and Binder Accessories,0.38
814,"Tenex File Box, Personal Filing Tote with Lid, Black",Justin Knight,24132,-47.97,15.51,17.78,British Columbia,Storage & Organization,0.59
815,1726 Digital Answering Machine,Luke Weiss,24576,24.56,20.99,4.81,British Columbia,Telephones and Communication,0.58
816,DAX Clear Channel Poster Frame,Luke Weiss,24576,38.02,14.58,7.4,British Columbia,Office Furnishings,0.48
817,"80 Minute Slim Jewel Case CD-R , 10/Pack - Staples",Christina Vanderzanden,25248,29.21,8.33,1.99,British Columbia,Computer Peripherals,0.52
818,Xerox 1891,Christina Vanderzanden,25248,418.19,48.91,5.81,British Columbia,Paper,0.38
819,Xerox 220,Lena Cacioppo,25475,-191.49,6.48,7.49,British Columbia,Paper,0.37
820,Computer Printout Paper with Letter-Trim Perforations,Seth Vernon,26978,-21.20,18.97,9.03,British Columbia,Paper,0.37
821,Wausau Papers Astrobrights® Colored Envelopes,Sanjit Chand,27105,39.63,5.98,2.5,British Columbia,Envelopes,0.36
822,"Executive Impressions 8-1/2 Career Panel/Partition Cubicle Clock",Sanjit Chand,27105,26.21,10.4,5.4,British Columbia,Office Furnishings,0.51
823,Belkin MediaBoard 104- Keyboard,Julie Creighton,28068,-43.96,27.48,4,British Columbia,Computer Peripherals,0.75
824,"Executive Impressions 12 Wall Clock",Sanjit Chand,28802,51.36,17.67,8.99,British Columbia,Office Furnishings,0.47
825,Southworth 25% Cotton Antique Laid Paper & Envelopes,Sanjit Chand,28802,25.95,8.34,4.82,British Columbia,Paper,0.4
826,6185,Sanjit Chand,28802,884.91,205.99,3,British Columbia,Telephones and Communication,0.58
827,"Eldon Spacemaker® Box, Quick-Snap Lid, Clear",Anthony Johnson,28839,-175.86,3.34,7.49,British Columbia,Pens & Art Supplies,0.54
828,Xerox 1995,Anthony Johnson,29252,-15.44,6.48,5.19,British Columbia,Paper,0.37
829,Honeywell Quietcare HEPA Air Cleaner,Kimberly Carter,31941,650.73,78.65,13.99,British Columbia,Appliances,0.52
830,Xerox 1993,Kimberly Carter,31941,-43.50,6.48,9.68,British Columbia,Paper,0.36
831,"Hon Deluxe Fabric Upholstered Stacking Chairs, Rounded Back",Marina Lichtenstein,32418,-131.31,243.98,43.32,British Columbia,Chairs & Chairmats,0.55
832,"Strathmore #10 Envelopes, Ultimate White",Sanjit Chand,34241,16.23,52.71,2.5,British Columbia,Envelopes,0.36
833,Fellowes 8 Outlet Superior Workstation Surge Protector,Sally Knutson,34816,267.16,41.71,4.5,British Columbia,Appliances,0.56
834,"Tyvek Interoffice Envelopes, 9 1/2 x 12 1/2, 100/Box",Sally Knutson,34816,590.77,60.98,19.99,British Columbia,Envelopes,0.38
835,Fiskars® Softgrip Scissors,Luke Weiss,35011,-2.31,10.98,3.37,British Columbia,"Scissors, Rulers and Trimmers",0.57
836,Sanyo 2.5 Cubic Foot Mid-Size Office Refrigerators,Anthony Johnson,36068,1243.17,279.81,23.19,British Columbia,Appliances,0.59
837,Accessory20,Michelle Arnett,36930,1325.82,85.99,3.3,British Columbia,Telephones and Communication,0.37
838,Xerox 1971,Luke Weiss,37315,-133.68,4.28,5.17,British Columbia,Paper,0.4
839,5165,Luke Weiss,37315,1176.48,175.99,4.99,British Columbia,Telephones and Communication,0.59
840,Lexmark Z54se Color Inkjet Printer,Luke Weiss,37925,1265.82,90.97,14,British Columbia,Office Machines,0.36
841,StarTAC 7760,Luke Weiss,37925,394.45,65.99,3.99,British Columbia,Telephones and Communication,0.59
842,"Premier Elliptical Ring Binder, Black",Rob Haberlin,38021,709.33,30.44,1.49,British Columbia,Binders and Binder Accessories,0.37
843,Wilson Jones DublLock® D-Ring Binders,Julie Creighton,38336,2.82,6.75,2.99,British Columbia,Binders and Binder Accessories,0.35
844,Micro Innovations 104 Keyboard,Julie Creighton,38336,-116.45,10.97,6.5,British Columbia,Computer Peripherals,0.64
845,"Eldon Expressions Punched Metal & Wood Desk Accessories, Pewter & Cherry",Justin Knight,38565,-11.69,10.64,5.16,British Columbia,Office Furnishings,0.57
846,Eureka Disposable Bags for Sanitaire® Vibra Groomer I® Upright Vac,Sally Knutson,39783,-94.76,4.06,6.89,British Columbia,Appliances,0.6
847,GBC Standard Plastic Binding Systems Combs,Sally Knutson,39783,5.02,8.85,5.6,British Columbia,Binders and Binder Accessories,0.36
848,Avery 520,Sally Knutson,39783,39.90,3.15,0.5,British Columbia,Labels,0.37
849,"Fellowes Premier Superior Surge Suppressor, 10-Outlet, With Phone and Remote",Michelle Arnett,42500,437.07,48.92,4.5,British Columbia,Appliances,0.59
850,"Cardinal Slant-D® Ring Binder, Heavy Gauge Vinyl",Michelle Arnett,42500,-10.48,8.69,2.99,British Columbia,Binders and Binder Accessories,0.39
851,Fiskars® Softgrip Scissors,Julie Creighton,44162,42.76,10.98,3.37,British Columbia,"Scissors, Rulers and Trimmers",0.57
852,"TOPS Money Receipt Book, Consecutively Numbered in Red,",Sally Knutson,44256,48.45,8.01,2.87,British Columbia,Paper,0.4
853,Xerox 226,Sally Knutson,44256,-38.72,6.48,5.84,British Columbia,Paper,0.37
854,Sanford 52201 APSCO Electric Pencil Sharpener,Sally Knutson,44256,182.15,40.97,8.99,British Columbia,Pens & Art Supplies,0.59
855,Laminate Occasional Tables,Sally Knutson,44320,-1640.51,154.13,69,British Columbia,Tables,0.68
856,Round Ring Binders,Kimberly Carter,45377,-22.90,2.08,1.49,British Columbia,Binders and Binder Accessories,0.38
857,Durable Pressboard Binders,Rob Haberlin,47367,-0.17,3.8,1.49,British Columbia,Binders and Binder Accessories,0.38
858,Avery 52,Rob Haberlin,47367,2.28,3.69,0.5,British Columbia,Labels,0.38
859,Avery 492,Sally Knutson,47750,36.64,2.88,0.5,British Columbia,Labels,0.39
860,"Executive Impressions 13 Chairman Wall Clock",Sally Knutson,47750,216.12,25.38,8.99,British Columbia,Office Furnishings,0.5
861,Binder Posts,Marina Lichtenstein,48388,-13.33,5.74,5.01,British Columbia,Binders and Binder Accessories,0.39
862,Avery 498,Christina DeMoss,49059,45.51,2.89,0.5,British Columbia,Labels,0.38
863,Xerox 1891,Christina DeMoss,49059,32.86,48.91,5.81,British Columbia,Paper,0.38
864,DIXON Oriole® Pencils,Luke Weiss,49510,-6.22,2.58,1.3,British Columbia,Pens & Art Supplies,0.59
865,Avery Durable Binders,Sally Knutson,49634,10.91,2.88,1.49,British Columbia,Binders and Binder Accessories,0.36
866,Avery 510,Michelle Arnett,50210,82.30,3.75,0.5,British Columbia,Labels,0.37
867,"Super Bands, 12/Pack",Michelle Arnett,50210,-30.26,1.86,2.58,British Columbia,Rubber Bands,0.82
868,iDEN i95,Sanjit Chand,50503,-186.33,65.99,19.99,British Columbia,Telephones and Communication,0.59
869,Staples 6 Outlet Surge,Anthony Johnson,50816,-35.94,11.97,4.98,British Columbia,Appliances,0.58
870,Lock-Up Easel 'Spel-Binder',Anthony Johnson,50816,302.80,28.53,1.49,British Columbia,Binders and Binder Accessories,0.38
871,"Memorex 4.7GB DVD+R, 3/Pack",Anthony Johnson,50816,-12.46,15.28,1.99,British Columbia,Computer Peripherals,0.42
872,"3M Polarizing Task Lamp with Clamp Arm, Light Gray",Luke Weiss,51073,958.80,136.98,24.49,British Columbia,Office Furnishings,0.59
873,"Advantus Employee of the Month Certificate Frame, 11 x 13-1/2",Luke Weiss,51073,813.35,30.93,3.92,British Columbia,Office Furnishings,0.44
874,Office Star Flex Back Scooter Chair with White Frame,Rob Haberlin,51584,176.04,110.98,30,British Columbia,Chairs & Chairmats,0.71
875,"Howard Miller 11-1/2 Diameter Ridgewood Wall Clock",Monica Federle,51879,372.26,51.94,19.99,British Columbia,Office Furnishings,0.44
876,Southworth 25% Cotton Premium Laser Paper and Envelopes,Monica Federle,51879,212.06,19.98,8.68,British Columbia,Paper,0.37
877,Howard Miller 12-3/4 Diameter Accuwave DS ™ Wall Clock,Kimberly Carter,52288,545.11,78.69,19.99,British Columbia,Office Furnishings,0.43
878,Lock-Up Easel 'Spel-Binder',Michelle Arnett,53190,74.64,28.53,1.49,British Columbia,Binders and Binder Accessories,0.38
879,StarTAC 7760,Michelle Arnett,53190,-170.53,65.99,3.99,British Columbia,Telephones and Communication,0.59
880,"Seth Thomas 12 Clock w/ Goldtone Case",Sanjit Chand,53536,109.16,22.98,7.58,British Columbia,Office Furnishings,0.51
881,Bevis Round Conference Room Tables and Bases,Sanjit Chand,53536,-234.59,179.29,56.2,British Columbia,Tables,0.71
882,#10 Self-Seal White Envelopes,Marina Lichtenstein,53572,4.79,11.09,5.25,British Columbia,Envelopes,0.36
883,Xerox 1885,Joy Smith,53825,649.80,48.04,7.23,British Columbia,Paper,0.37
884,Fellowes Super Stor/Drawer® Files,Christina DeMoss,53863,1660.15,161.55,19.99,British Columbia,Storage & Organization,0.66
885,"Advantus Push Pins, Aluminum Head",Monica Federle,54119,-43.45,5.81,3.37,British Columbia,Rubber Bands,0.54
886,Acco Perma® 2700 Stacking Storage Drawers,Monica Federle,54119,-41.75,29.74,6.64,British Columbia,Storage & Organization,0.7
887,"Acco Pressboard Covers with Storage Hooks, 14 7/8 x 11, Dark Blue",Michelle Arnett,56224,-117.27,3.81,5.44,British Columbia,Binders and Binder Accessories,0.36
888,Bevis Steel Folding Chairs,Michelle Arnett,56224,-1115.99,95.95,74.35,British Columbia,Chairs & Chairmats,0.57
889,"Staples Vinyl Coated Paper Clips, 800/Box",Michelle Arnett,56224,48.59,7.89,2.82,British Columbia,Rubber Bands,0.4
890,Bevis 36 x 72 Conference Tables,Michelle Arnett,56224,-153.25,124.49,51.94,British Columbia,Tables,0.63
891,Telescoping Adjustable Floor Lamp,Michelle Arnett,56293,-44.81,19.99,11.17,British Columbia,Office Furnishings,0.6
892,"Tenex Personal Self-Stacking Standard File Box, Black/Gray",Michelle Arnett,56293,-27.72,16.91,6.25,British Columbia,Storage & Organization,0.58
893,"Advantus Push Pins, Aluminum Head",Sally Knutson,57959,-32.06,5.81,3.37,British Columbia,Rubber Bands,0.54
894,"Micro Innovations Micro 3000 Keyboard, Black",Sally Knutson,57959,-65.33,26.31,5.89,British Columbia,Computer Peripherals,0.75
895,LX 677,Christina DeMoss,58500,14.01,110.99,8.99,British Columbia,Telephones and Communication,0.57
896,"Bush Westfield Collection Bookcases, Fully Assembled",Joy Smith,59584,-160.46,100.98,35.84,British Columbia,Bookcases,0.62
897,Canon MP41DH Printing Calculator,Joy Smith,59584,16.81,150.98,13.99,British Columbia,Office Machines,0.38
898,7160,Sonia Sunley,261,1680.79,140.99,4.2,British Columbia,Telephones and Communication,0.59
899,Belkin 8 Outlet SurgeMaster II Gold Surge Protector,Anthony O'Donnell,928,300.97,59.98,3.99,British Columbia,Appliances,0.57
900,DAX Clear Channel Poster Frame,Anthony O'Donnell,928,45.00,14.58,7.4,British Columbia,Office Furnishings,0.48
901,"Memorex 4.7GB DVD-RAM, 3/Pack",Emily Grady,1282,366.48,31.78,1.99,British Columbia,Computer Peripherals,0.42
902,Prang Drawing Pencil Set,Emily Grady,1282,-2.06,2.78,1.34,British Columbia,Pens & Art Supplies,0.45
903,Euro Pro Shark Stick Mini Vacuum,Alex Avila,1856,-712.14,60.98,49,British Columbia,Appliances,0.59
904,M3682,Alex Avila,1856,973.16,125.99,8.08,British Columbia,Telephones and Communication,0.57
905,StarTAC 6500,Alex Avila,1856,676.13,125.99,8.8,British Columbia,Telephones and Communication,0.59
906,SAFCO Arco Folding Chair,Brian Moss,1925,67.84,276.2,24.49,British Columbia,Chairs & Chairmats,
907,Eldon Advantage® Chair Mats for Low to Medium Pile Carpets,Emily Grady,2848,-303.62,43.31,15.9,British Columbia,Office Furnishings,0.75
908,SC7868i,Emily Grady,2848,-264.28,125.99,8.99,British Columbia,Telephones and Communication,0.55
909,HP Office Recycled Paper (20Lb. and 87 Bright),Anna Andreadi,5504,-20.33,5.78,7.64,British Columbia,Paper,0.36
910,KF 788,Anna Andreadi,5504,20.23,45.99,4.99,British Columbia,Telephones and Communication,0.56
911,Logitech Internet Navigator Keyboard,Emily Grady,8390,-99.34,30.98,4,British Columbia,Computer Peripherals,0.8
912,ACCOHIDE® Binder by Acco,Barbara Fisher,8545,-77.34,4.13,5.34,British Columbia,Binders and Binder Accessories,0.38
913,"O'Sullivan Elevations Bookcase, Cherry Finish",Barbara Fisher,8545,-662.80,130.98,54.74,British Columbia,Bookcases,0.69
914,Serrated Blade or Curved Handle Hand Letter Openers,Emily Grady,9573,-59.91,3.14,1.92,British Columbia,"Scissors, Rulers and Trimmers",0.84
915,"Tyvek ® Top-Opening Peel & Seel Envelopes, Plain White",Kelly Williams,9892,424.36,27.18,8.23,British Columbia,Envelopes,0.38
916,Keytronic 105-Key Spanish Keyboard,Sonia Sunley,10048,97.16,73.98,4,British Columbia,Computer Peripherals,0.77
917,"*Staples* vLetter Openers, 2/Pack",Sonia Sunley,10048,-20.65,3.68,1.32,British Columbia,"Scissors, Rulers and Trimmers",0.83
918,Hon 4700 Series Mobuis™ Mid-Back Task Chairs with Adjustable Arms,Sonia Sunley,10144,103.83,355.98,58.92,British Columbia,Chairs & Chairmats,0.64
919,Office Star - Mid Back Dual function Ergonomic High Back Chair with 2-Way Adjustable Arms,Sonia Sunley,10144,-98.30,160.98,30,British Columbia,Chairs & Chairmats,0.62
920,Global Adaptabilities™ Conference Tables,Sonia Sunley,10144,539.54,280.98,35.67,British Columbia,Tables,0.66
921,Motorola SB4200 Cable Modem,Sonia Sunley,10432,220.39,179.99,19.99,British Columbia,Computer Peripherals,0.48
922,"Acme Design Line 8 Stainless Steel Bent Scissors w/Champagne Handles, 3-1/8 Cut",Jocasta Rupert,10661,-99.34,6.84,8.37,British Columbia,"Scissors, Rulers and Trimmers",0.58
923,Jet-Pak Recycled Peel 'N' Seal Padded Mailers,Sonia Sunley,12806,107.93,35.89,14.72,British Columbia,Envelopes,0.4
924,Wilson Jones DublLock® D-Ring Binders,Kelly Williams,13158,29.33,6.75,2.99,British Columbia,Binders and Binder Accessories,0.35
925,Strathmore Photo Mount Cards,Anna Andreadi,13507,-75.71,6.78,6.18,British Columbia,Paper,0.39
926,Xerox 1978,Rick Duston,14375,-21.77,5.78,5.67,British Columbia,Paper,0.36
927,"GBC White Gloss Covers, Plain Front",Sonia Sunley,14627,67.86,14.48,6.46,British Columbia,Binders and Binder Accessories,0.38
928,GBC DocuBind 200 Manual Binding Machine,Angele Hood,14852,1234.57,420.98,19.99,British Columbia,Binders and Binder Accessories,0.35
929,Self-Adhesive Address Labels for Typewriters by Universal,Sonia Sunley,16230,-7.86,7.31,0.49,British Columbia,Labels,0.38
930,"O'Sullivan Elevations Bookcase, Cherry Finish",Sonia Sunley,16230,-801.09,130.98,54.74,British Columbia,Bookcases,0.69
931,Xerox 1891,Sonia Sunley,16230,223.76,48.91,5.81,British Columbia,Paper,0.38
932,Fellowes Recycled Storage Drawers,Sonia Sunley,16230,506.86,111.03,8.64,British Columbia,Storage & Organization,0.78
933,"1.7 Cubic Foot Compact Cube Office Refrigerators",Sonia Sunley,19074,191.47,208.16,68.02,British Columbia,Appliances,0.58
934,"DAX Contemporary Wood Frame with Silver Metal Mat, Desktop, 11 x 14 Size",Dennis Bolton,20194,68.89,20.24,6.67,British Columbia,Office Furnishings,0.49
935,Newell 312,Stewart Carmichael,21024,33.80,5.84,1.2,British Columbia,Pens & Art Supplies,0.55
936,Avery 487,Dennis Bolton,21509,15.82,3.69,0.5,British Columbia,Labels,0.38
937,Avery 487,Sonia Sunley,21856,71.77,3.69,0.5,British Columbia,Labels,0.38
938,Serrated Blade or Curved Handle Hand Letter Openers,Sonia Sunley,21856,-47.75,3.14,1.92,British Columbia,"Scissors, Rulers and Trimmers",0.84
939,"Eureka Hand Vacuum, Bagless",Stewart Carmichael,22119,-122.77,49.43,19.99,British Columbia,Appliances,0.57
940,Airmail Envelopes,Kelly Williams,22534,-44.18,83.93,19.99,British Columbia,Envelopes,0.38
941,Keytronic French Keyboard,Sonia Sunley,22629,-243.02,73.98,14.52,British Columbia,Computer Peripherals,0.65
942,TDK 4.7GB DVD-R,Kelly Williams,23011,-33.93,10.01,1.99,British Columbia,Computer Peripherals,0.41
943,"Pressboard Covers with Storage Hooks, 9 1/2 x 11, Light Blue",Sonia Sunley,24070,-98.31,4.91,4.97,British Columbia,Binders and Binder Accessories,0.38
944,Hon Olson Stacker Stools,Sonia Sunley,24070,-164.59,140.81,24.49,British Columbia,Chairs & Chairmats,0.57
945,Newell 314,Sonia Sunley,24070,88.80,5.58,0.7,British Columbia,Pens & Art Supplies,0.6
946,Global Ergonomic Managers Chair,Sonia Sunley,24737,-210.97,180.98,26.2,British Columbia,Chairs & Chairmats,0.59
947,Xerox 1995,Sonia Sunley,24737,-28.15,6.48,5.19,British Columbia,Paper,0.37
948,Belkin 8 Outlet Surge Protector,Anna Andreadi,26373,2.30,40.98,5.33,British Columbia,Appliances,0.57
949,Canon Image Class D660 Copier,Seth Vernon,26978,-635.69,599.99,24.49,British Columbia,Copiers and Fax,0.44
950,Xerox 1919,Seth Vernon,26978,938.26,40.99,5.86,British Columbia,Paper,0.36
951,Eldon Jumbo ProFile™ Portable File Boxes Graphite/Black,Seth Vernon,26978,-157.44,15.31,8.78,British Columbia,Storage & Organization,0.57
952,Accessory27,Alex Avila,27174,-245.56,35.99,5,British Columbia,Telephones and Communication,0.85
953,Berol Giant Pencil Sharpener,Sarah Foster,27876,-70.54,16.99,8.99,British Columbia,Pens & Art Supplies,0.56
954,Verbatim DVD-R 4.7GB authoring disc,Alex Avila,28582,423.87,39.24,1.99,British Columbia,Computer Peripherals,0.51
955,"TOPS Money Receipt Book, Consecutively Numbered in Red,",Alex Avila,28582,87.96,8.01,2.87,British Columbia,Paper,0.4
956,Xerox 227,Anna Andreadi,28868,-142.30,6.48,8.73,British Columbia,Paper,0.37
957,"Sauder Forest Hills Library, Woodland Oak Finish",Angele Hood,29857,-639.47,140.98,36.09,British Columbia,Bookcases,0.77
958,GBC VeloBinder Electric Binding Machine,Sonia Sunley,29921,1733.47,120.98,9.07,British Columbia,Binders and Binder Accessories,0.35
959,Accessory4,Kelly Williams,30659,-106.51,85.99,0.99,British Columbia,Telephones and Communication,0.85
960,"Lesro Sheffield Collection Coffee Table, End Table, Center Table, Corner Table",Anna Andreadi,30660,-647.14,71.37,69,British Columbia,Tables,0.68
961,"Adams Phone Message Book, Professional, 400 Message Capacity, 5 3/6” x 11”",Alex Avila,30883,59.84,6.98,1.6,British Columbia,Paper,0.38
962,Microsoft Internet Keyboard,Jim Karlsson,32871,9.72,20.97,4,British Columbia,Computer Peripherals,0.77
963,Xerox 1962,Sonia Sunley,33600,-94.36,4.28,4.79,British Columbia,Paper,0.4
964,636,Alex Avila,33632,-277.78,115.99,5.26,British Columbia,Telephones and Communication,0.57
965,Global Commerce™ Series High-Back Swivel/Tilt Chairs,Lisa DeCherney,33665,1063.46,284.98,69.55,British Columbia,Chairs & Chairmats,0.6
966,Wilson Jones Easy Flow II™ Sheet Lifters,Barbara Fisher,34434,-63.19,1.8,4.79,British Columbia,Binders and Binder Accessories,0.37
967,Avery White Multi-Purpose Labels,Barbara Fisher,34434,50.66,4.98,0.49,British Columbia,Labels,0.39
968,Accessory25,Barbara Fisher,34753,-63.70,20.99,0.99,British Columbia,Telephones and Communication,0.57
969,Xerox 199,Lisa DeCherney,35364,-54.75,4.28,5.68,British Columbia,Paper,0.4
970,Bretford Rectangular Conference Table Tops,Lisa DeCherney,35364,-871.52,376.13,85.63,British Columbia,Tables,0.74
971,Bush Advantage Collection® Racetrack Conference Table,Lisa DeCherney,35364,455.02,424.21,110.2,British Columbia,Tables,0.67
972,T28 WORLD,Lisa DeCherney,35364,-554.44,195.99,8.99,British Columbia,Telephones and Communication,0.6
973,Hon Comfortask® Task/Swivel Chairs,Barbara Fisher,35812,-112.62,113.98,30,British Columbia,Chairs & Chairmats,0.69
974,Fellowes 17-key keypad for PS/2 interface,Barbara Fisher,35812,-147.81,30.73,4,British Columbia,Computer Peripherals,0.75
975,Xerox 1938,Barbara Fisher,35812,307.64,47.9,5.86,British Columbia,Paper,0.37
976,"Executive Impressions 12 Wall Clock",Alex Avila,37063,89.60,17.67,8.99,British Columbia,Office Furnishings,0.47
977,1726 Digital Answering Machine,Roy Skaria,37281,3.31,20.99,4.81,British Columbia,Telephones and Communication,0.58
978,Hon 4070 Series Pagoda™ Armless Upholstered Stacking Chairs,Angele Hood,37798,813.49,291.73,48.8,British Columbia,Chairs & Chairmats,0.56
979,Rediform S.O.S. Phone Message Books,Seth Vernon,38017,45.14,4.98,0.8,British Columbia,Paper,0.36
980,StarTAC 3000,Seth Vernon,38017,453.65,125.99,7.69,British Columbia,Telephones and Communication,0.59
981,Staples® General Use 3-Ring Binders,Sarah Foster,38272,-20.65,1.88,1.49,British Columbia,Binders and Binder Accessories,0.37
982,Adesso Programmable 142-Key Keyboard,Kelly Williams,39301,-521.09,152.48,4,British Columbia,Computer Peripherals,0.79
983,"ACCOHIDE® 3-Ring Binder, Blue, 1",Dennis Bolton,39367,-146.97,4.13,5.04,British Columbia,Binders and Binder Accessories,0.38
984,Ampad #10 Peel & Seel® Holiday Envelopes,Dennis Bolton,39367,5.90,4.48,2.5,British Columbia,Envelopes,0.37
985,"Imation 3.5 DS-HD Macintosh Formatted Diskettes, 10/Pack",Roy Skaria,39655,-72.43,7.28,3.52,British Columbia,Computer Peripherals,0.68
986,Durable Pressboard Binders,Jim Karlsson,40803,9.24,3.8,1.49,British Columbia,Binders and Binder Accessories,0.38
987,"Global Leather and Oak Executive Chair, Black",Jim Karlsson,40803,1512.07,300.98,64.73,British Columbia,Chairs & Chairmats,0.56
988,3M Organizer Strips,Barbara Fisher,40806,-41.26,5.4,7.78,British Columbia,Binders and Binder Accessories,0.37
989,Xerox 1983,Anna Andreadi,43523,-97.23,5.98,5.46,British Columbia,Paper,0.36
990,Advantus Map Pennant Flags and Round Head Tacks,Seth Vernon,44199,-6.33,3.95,2,British Columbia,Rubber Bands,0.53
991,Office Star - Mid Back Dual function Ergonomic High Back Chair with 2-Way Adjustable Arms,Alex Avila,44231,116.10,160.98,30,British Columbia,Chairs & Chairmats,0.62
992,"Belkin 107-key enhanced keyboard, USB/PS/2 interface",Alex Avila,44231,-87.96,17.98,4,British Columbia,Computer Peripherals,0.79
993,5185,Alex Avila,44231,311.64,115.99,8.99,British Columbia,Telephones and Communication,0.58
994,Hon Every-Day® Chair Series Swivel Task Chairs,Sonia Sunley,45573,-151.46,120.98,30,British Columbia,Chairs & Chairmats,0.64
995,Avery 494,Lisa DeCherney,45763,24.28,2.61,0.5,British Columbia,Labels,0.39
996,Xerox 1905,Dennis Bolton,48165,-147.27,6.48,9.54,British Columbia,Paper,0.37
997,Dana Halogen Swing-Arm Architect Lamp,Anthony O'Donnell,48197,154.74,40.97,14.45,British Columbia,Office Furnishings,0.57
998,Maxell DVD-RAM Discs,Barbara Fisher,48484,67.96,16.48,1.99,British Columbia,Computer Peripherals,0.42
999,"DAX Contemporary Wood Frame with Silver Metal Mat, Desktop, 11 x 14 Size",Barbara Fisher,48484,133.83,20.24,6.67,British Columbia,Office Furnishings,0.49
1000,Computer Printout Paper with Letter-Trim Perforations,Barbara Fisher,48484,153.80,18.97,9.03,British Columbia,Paper,0.37
"""#
