(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



(* ::Subsubsection::Closed:: *)
(*PacletServerExecute*)



$PacletServers::usage=
		"The listing of possible servers";
$PacletServer::usage=
	"The configuration for the default paclet server";
PacletServerExecute::usage=
	"Runs functions on a paclet server";


(* ::Subsubsection::Closed:: *)
(*Add / Remove*)



PacletServerAdd::usage=
	"Adds a paclet to the default server";
PacletServerRemove::usage=
	"Removes a paclet from the default server";


PacletServerBuild::usage="Builds a paclet server and site";
PacletServerDeploy::usage="Deploys a paclet server";


PacletServerInterface::usage=
	"Generates an interface listing what's on a paclet server with install buttons"


Begin["`Private`"];


(* ::Subsection:: *)
(*Server Basics*)



(* ::Subsubsection::Closed:: *)
(*patternHack*)



pacletUploadPat=((_String|_URL|_File|{_String,_String}|_Paclet)|
	(_String|_Paclet->_String|_URL|_File|{_String,_String}|_Paclet))|
	{((_String|_URL|_File|{_String,_String}|_Paclet)|
			(_String|_Paclet->_String|_URL|_File|{_String,_String}|_Paclet))..};


LocalPacletServerPattern=
	KeyValuePattern[{
		"ServerBase"->
			(
				_String?DirectoryQ|
				_String?(MatchQ[URLParse[#, "Scheme"], "file"|"http"]&)
				),
		"ServerName"->_
		}];


localPacletServerPatOrDir=
	LocalPacletServerPattern|_String?DirectoryQ;
localPacletServer=
	MatchQ[LocalPacletServerPattern]


(* ::Subsubsection::Closed:: *)
(*Setup*)



If[!AssociationQ@$PacletServers,
	LoadPacletServers[]
	]


$PacletServer:=
	PacletServer[$DefaultPacletServer]


(* ::Subsubsection::Closed:: *)
(*PacletServerExecute*)



PacletServerExecute//Clear


$PacletServerExecuteFunctions=
	<|
		"URL"->
			PacletServerURL,
		"DeploymentURL"->
			PacletServerDeploymentURL,
		"Directory"->
			PacletServerDirectory,
		"Path"->
			PacletServerFile,
		"ExposedPaclets"->
			PacletServerExposedPaclets,
		"Dataset"->
			PacletServerDataset,
		"BundleSite"->
			PacletServerBundleSite
		|>;
PacletServerExecute[
	k_?(KeyExistsQ[$PacletServerExecuteFunctions, #]&),
	server:localPacletServerPatOrDir,
	args___
	]:=
	With[{fn=$PacletServerExecuteFunctions[k]},
		With[{res=fn[server, args]},
			res/;Head[res]=!=fn
			]
		];
PacletServerExecute[
	k_?(KeyExistsQ[$PacletServerExecuteFunctions, #]&),
	s_String?(KeyExistsQ[$PacletServers, #]&),
	args___
	]:=
	With[{r=PacletServerExecute[k, $PacletServers[s], args]},
		r/;Head[r]=!=PacletServerExecute
		];


PackageAddAutocompletions[
	"PacletServerExecute",
	{
		Keys@$PacletServerExecuteFunctions,
		Keys@$PacletServers
		}
	]


(* ::Subsection:: *)
(*PacletServerInterface*)



(* ::Subsubsection::Closed:: *)
(*pacletServerInterfacePage*)



pacletServerInterfacePage[
	var_,
	site_,
	coreAssoc_,
	pacletFindData_
	]:=
	With[{
		name=coreAssoc["Name"],
		version=coreAssoc["Version"],
		creator=Lookup[coreAssoc, "Creator", ""],
		description=Lookup[coreAssoc,"Description",""],
		extensions=
			Replace[
				Lookup[coreAssoc,"Extensions",Nothing],
				ds_Association:>Dataset[ds]
				]
		},
		Grid[{
			{
				Item[
					Row@{Style[name, Bold],Style[" v"<>version,Gray]},
					Background->GrayLevel[.8],
					Alignment->Center,
					ItemSize->{Automatic, 2},
					FrameStyle->Black
					],
					SpanFromLeft
				},
			{
				Item[#, Alignment->Left]&@
				Row@{Style["Creator: ",Gray], 
					Replace[Interpreter["EmailAddress"][creator],{
						s_String?(StringLength[#]>0&):>
							Hyperlink[creator, "mailto:"<>creator],
						_->creator
						}]},
				SpanFromLeft
				},
			{
				TextCell[description,
					CellSize->{500,Automatic},
					ParagraphIndent->None,
					Editable->False,
					Selectable->True
					],
				SpanFromLeft
				},
			{
				Item[
					"Extensions",
					Alignment->Center,
					Background->GrayLevel[.98]
					],
				SpanFromLeft
				},
			{
				Item[#, Alignment->Left]&@
				Grid[
					KeyValueMap[
						{
							Style[Row[{#, ": "}], Gray],
							Which[
								MatchQ[#2, <||>|<|Prepend->True|>],
									Grid[{{},{"Enabled"}}, Alignment->{Left, Top}],
								AssociationQ@#2,
									Grid[
										Prepend[{}]@
										KeyValueMap[
											{
												Style[Row[{#, ": "}], Gray],
												#2
												}&,
											DeleteDuplicates@#2
											],
										Alignment->{Left, Top}
										],
								True,
									#2
								]
							}&,
						Normal@extensions
						],
					Alignment->{Left, Top}
					],
				SpanFromLeft
				},
			{
				Item[
					Button[Hyperlink@"\[ReturnIndicator]",
						var=Automatic,
						Appearance->None,
						BaseStyle->"Hyperlink"
						],
					Alignment->Left,
					Background->GrayLevel[.95]
					],
				Item[
					Dynamic[
						refreshFlag;
						If[Length[PacletManager`PacletFind[name]]==0,
							Button["Install",
								PacletManager`PacletInstall[name,
									"Site"->site
									];
								refreshFlag=RandomReal[],
								Enabled->StringQ[site],
								ImageSize->160,
								Method->"Queued"
								],
							Grid[
								{
									{
										Button["Update",
											PacletManager`PacletUpdate[name,
												"Site"->site,
												"UpdateSites"->False
												];
											refreshFlag=RandomReal[],
											Enabled->
												StringQ[site]&&
												AllTrue[
													ToExpression/@
														StringSplit[Lookup[pacletFindData,"Version"],"."],
													!OrderedQ[
														ToExpression@StringSplit[coreAssoc["Version"],"."],
														#
														]&
													],
											ImageSize->80,
											Appearance->"AbuttingRight"
											],
										Button["Uninstall",
											PacletManager`PacletUninstall[name];
											refreshFlag=RandomReal[],
											ImageSize->80,
											Appearance->"AbuttingLeft"
											]
										}
									},
								Spacings->{.1,0},
								Dividers->{{2->GrayLevel[.8]}, {}}
								]
							],
						TrackedSymbols:>{refreshFlag}
						],
					Alignment->Right
					]
				}
			},
			BaseStyle->"Text",
			Frame->True,
			FrameStyle->GrayLevel[.8],
			Dividers->{
				Automatic, 
				{
					1->Black,
					2->GrayLevel[.4],
					3->GrayLevel[.8],
					4->GrayLevel[.8],
					5->GrayLevel[.8],
					6->GrayLevel[.4]
					}
				},
			Background->{{-1->GrayLevel[.98]}}
			]
		];
pacletServerInterfacePage~SetAttributes~HoldFirst


(* ::Subsubsection::Closed:: *)
(*pacletServerInterfaceEntry*)



pacletServerInterfaceEntry[
	var_,
	site_,
	coreAssoc_,
	pacletFindData_
	]:=
	With[{
		name=coreAssoc["Name"],
		version=coreAssoc["Version"],
		creator=Lookup[coreAssoc, "Creator", ""],
		description=Lookup[coreAssoc,"Description",""],
		page=
			pacletServerInterfacePage[var,site,coreAssoc,pacletFindData]
		},
		{
			(* Name *)
			Button[
				Hyperlink@name,
				var=page,
				Appearance->None,
				BaseStyle->"Hyperlink"
				],
			(* Version *)
			Row@{"v",version},
			(* Creator *)
			creator,
			(* Update / Install *)
			Dynamic[
				refreshFlag;
				If[Length[PacletManager`PacletFind[name]]===0,
					Button["Install",
						PacletManager`PacletInstall[name,"Site"->site];
						refreshFlag=RandomReal[],
						ImageSize->160,
						Method->"Queued"
						],
					Grid[
						{
							{
								Button["Update",
									PacletManager`PacletUpdate[name,
										"Site"->site,
										"UpdateSites"->False
										];
									refreshFlag=RandomReal[],
									ImageSize->80,
									Enabled->
										StringQ[site]&&
											AllTrue[
												ToExpression/@
													StringSplit[Lookup[pacletFindData,"Version"],"."],
												!OrderedQ[
													ToExpression@StringSplit[coreAssoc["Version"],"."],
													#
													]&
												],
									Appearance->"AbuttingRight"
									],
								Button["Uninstall",
									PacletManager`PacletUninstall[name];
									refreshFlag=RandomReal[],
									Appearance->"AbuttingLeft",
									ImageSize->80
									]
								}
							},
						Spacings->{.1,0},
						Dividers->{{2->GrayLevel[.8]}, {}}
						]
					],
				TrackedSymbols:>{refreshFlag}
				]
			}
		];
pacletServerInterfaceEntry~SetAttributes~HoldFirst;


(* ::Subsubsection::Closed:: *)
(*PacletServerInterface*)



PacletServerInterface//Clear


Options[PacletServerInterface]=
	Join[
		Options[Pane],
		Options[Grid]
		];
PacletServerInterface[
	siteBase:_String|_?OptionQ|None:None,
	siteDS_Dataset,
	displayStart:Except[_?OptionQ]:Automatic,
	ops:OptionsPattern[]
	]:=	
	With[{
		ds=
			DeleteDuplicatesBy[#["Name"]&]@
			SortBy[
				{
					Lookup[#,"Name"],
					100000+-ToExpression@StringSplit[Lookup[#, "Version", "1.0.0"],"."]
					}&
				]@Normal@siteDS,
		site=
			Replace[siteBase,
				o_?OptionQ:>
					PacletServerURL[o]
				]
		},
		DynamicModule[{
			main,
			display
			},
			display=
				If[StringQ@displayStart,
					With[{pf=PacletManager`PacletFind[displayStart]},
						If[Length@pf>0,
							pacletServerInterfacePage[
								display,
								siteDS,
								PacletInfoAssociation@
									pf[[1]],
								PacletInfoAssociation/@
									pf
								],
							Automatic
							]
						],
					Automatic
					];
			main=
				Pane[
					Grid[
						Prepend[
							Map[
								Item[
									Style[#, Bold],
									FrameStyle->Black,
									Alignment->{Left, Center},
									ItemSize->{Automatic, 2}
									]&,
								{"Name", "Version", "Creator", "Install"}
								]
							]@
						Map[
							pacletServerInterfaceEntry[
								display,
								site,
								#,
								PacletInfoAssociation/@
									PacletManager`PacletFind[#["Name"]]
								]&,
							ds
							],
						FilterRules[
							{
								ops,
								Background->
									{
										Automatic,
										Prepend[GrayLevel[.8]]@
											Flatten@ConstantArray[{White,GrayLevel[.95]},Length[ds]]
										},
								Frame->True,
								FrameStyle->GrayLevel[.8],
								Dividers->{
									Flatten@
										{
											Table[n+1->GrayLevel[.9],{n,3}]
											},
									Flatten@{
										Table[1+n->GrayLevel[.8],{n,Length[ds]-1}]
										}
									},
								BaseStyle->"Text",
								Alignment->Left
								},
							Options[Grid]
							]
						],
				FilterRules[{ops},
					Alternatives@@
						Complement[Keys[Options[Pane]],
							Keys@Options[Grid]
							]
					]
				];
			Dynamic[
				Replace[display,Automatic:>main],
				None
				]
			]
		];
PacletServerInterface[
	site:_String|_?OptionQ|Automatic:Automatic, 
	display:Except[_?OptionQ]:Automatic,
	ops:OptionsPattern[]
	]:=
	With[
		{s=
			Replace[site,
				{
					Automatic:>
						PacletServerURL[
							With[{
								f=
									FilterRules[
										{ops},
										Except[Alternatives@@Join[Keys@Options[Grid], Keys@Options[Pane]]]
										]
								},
								If[Length@f>0,
									f,
									$PacletServer
									]
								]
							],
					o_?OptionQ:>
						PacletServerURL[o]
					}
				]
			},
		PacletServerInterface[
			s,
			PacletSiteInfoDataset[s],
			display,
			ops
			]
		]


(* ::Subsection:: *)
(*Sites Layout*)



(*

The server structure looks like this:
	
	PacletServer
	
	   + Paclets
	   - PacletSite.mz
	   + content
	      + posts
	        - paclet1.nb
	        - paclet1.md
	        - paclet2.nb
	        - paclet2.md
	        ...
	      + pages
	        - about.md (??)
	        
	   - SiteConfig.m

When the server is built the Paclets and PacletSite.mz are copied to output for deployment

*)


(* ::Subsection:: *)
(*Single Page*)



$PacletServerTitle="Paclet Server";
$PacletServerDescription="";


pacletDownloadLine[
	pacletDownloadNB_,
	pacletDownloadURL_
	]:=
	XMLElement["div",
		{
			"class"->"paclet-download-line"
			},
		{
			XMLElement["a",
				{
					"href"->"wolfram+cloudobject:"<>pacletDownloadNB
					},
				{
					"Notebook"
					}
				],
			" | ",
			XMLElement["a",
				{
					"href"->pacletDownloadURL
					},
				{
					"Paclet"	
					}
				]
			}
		];


Options[pacletSectionXML]=
	Options[PacletInfoExpression];
pacletSectionXML[site_,ops:OptionsPattern[]]:=
	XMLElement["div",
		{
			"class"->"paclet-section",
			"id"->OptionValue["Name"]
			},
		{
			XMLElement["h3",
				{
					"class"->"paclet-name"
					},
				{
					OptionValue["Name"],
					XMLElement["span",
						{
							"class"->"paclet-version-text"
							},
						{
							" v"<>OptionValue["Version"],
							Replace[
								Replace[OptionValue["WolframVersion"],
									Except[_String]:>OptionValue["MathematicaVersion"]
									],{
								s_String:>
									" | Mathematica "<>s,
								_->Nothing
								}]
							}
						]
				}],
			XMLElement["div",
				{
					"class"->"paclet-section-box"
					},
				{
					pacletDownloadLine[
						URLBuild[{
							site,
							OptionValue["Name"]<>"-"<>
								OptionValue["Version"]<>".nb"
							}],
						URLBuild[{
							site,
							"Paclets",
							OptionValue["Name"]<>"-"<>
								OptionValue["Version"]<>".paclet"
							}]
						],
					XMLElement[
						"p",
						{
							"class"->"paclet-download-description"	
							},
						{
							Replace[
								OptionValue["Description"],
								Automatic->""
								]
							}
						]
					}
				]
			}
		];


$pacletServerCSS=
"
body { 
	background: #fafafa ;
	margin: 0;
	}
.paclet-server-title {
	width: 100%;
	margin: 0;
	padding: 10;
	left: 0;
	top: 0;
	border-bottom: 1px solid #b01919 ;
	background: #8f3939; 
	color: #fafafa;
	box-shadow: 0px 2px 2px #901919 ;
 }
.paclet-server-description { 
	color: #505050;
	margin-left: 20px;
 }
.paclet-section {
	margin-top: 25;
	margin-left: 20px;
	width: 95%;
	margin-bottom: 15px;
	box-shadow: 1px 1px 1px gray ;
	border-radius: 5px;
	}
.paclet-name {
	min-height: 25px;
	margin: 0;
	padding: 10;
	color: #fafafa;
	background: #3f3f3f;
	border: solid 1px #3f3f3f;
	box-shadow: 1px 2px 2px #5f5f5f;
	border-top-left-radius: 5px;
	border-top-right-radius: 5px;
	}
.paclet-section-box { 
	border-left: solid 1px gray;
	border-right: solid 1px gray;
	border-bottom: solid 1px gray;
	border-bottom-left-radius: 5px;
	border-bottom-right-radius: 5px; 
	background: #f6f6f6;
	margin: 0;
	margin-top: 2;
	padding: 10;
	min-height: 125px;
 }
.paclet-version-text { 
	color: gray; 
	}
a:link {
	color: gray;
	}
a:hover {
	color: #cf3939;
	}
a:visited {
	color: #8f3939;
	}
";


Options[pacletServerXML]={
	"Title"->Automatic,
	"Description"->Automatic
	};
pacletServerXML[
	site_,
	pacletSpecs:_Association|{___Association},
	ops:OptionsPattern[]
	]:=
	XMLElement["html",{},{
		XMLElement["head",{},
			{
				XMLElement["title",{},{
					Replace[
						Replace[OptionValue["Title"],
							Automatic|Default->$PacletServerTitle
							],
						Except[_String]->""
						]
					}],
				XMLElement["style",
					{},
					{
						$pacletServerCSS
						}
					]
		}],
		XMLElement["body",
			{},
			Flatten@{
				XMLElement["div",
					{
						"class"->"paclet-server-title"
						},
					{
						XMLElement["h2",{},{
							Replace[
								Replace[OptionValue["Title"],
									Automatic|Default->$PacletServerTitle
									],
								Except[_String]->""
								]
							}]
						}
					],
				XMLElement[
					"div",
					{
						"class"->"paclet-server-description"
						},
					{
						XMLElement["p",{},{
							Replace[
								Replace[OptionValue["Description"],
									Automatic|Default->$PacletServerDescription
									],
								Except[_String]->""
								]
							}]
						}
					],
				pacletSectionXML[site,#]&/@
					PacletServerExposedPaclets[pacletSpecs]
				}
			]
		}];


(* ::Subsubsection::Closed:: *)
(*PacletServerPage*)



Options[PacletServerPage]=
	Join[{
		Permissions->Automatic
		},
		Options[CloudExport],
		Options[PacletSiteURL],
		Options[pacletServerXML],{
		"Extension"->"main.html"
		}];
PacletServerPage[
	ops:OptionsPattern[]
	]:=
	Block[{
		pacletServer=
			PacletSiteURL[FilterRules[{ops},Options@PacletSiteURL]],
		pacletServerPageXML:=
			htmlExportString@
				pacletServerXML[
					pacletServer,
					Normal@PacletSiteInfoDataset[pacletServer],
					FilterRules[{ops},Options@pacletServerXML]
					]
		},
		If[StringStartsQ[pacletServer,"file:"],
			Export[
				FileNameJoin@
					Append[
						URLParse[pacletServer,"Path"],
						OptionValue@"Extension"
						],
				pacletServerPageXML,
				"Text"
				],
			CloudExport[
				HTMLTemplateNotebook;
				pacletServerPageXML,
				"HTML",
				URLBuild@{
					pacletServer,
					OptionValue@"Extension"
					},
				FilterRules[{
					ops,
					Permissions->pacletStandardServerPermissions@OptionValue[Permissions]
					},
					Options@CloudExport]
				]
			]
	]


(* ::Subsection:: *)
(*Add / Remove*)



(* ::Subsubsection::Closed:: *)
(*PacletServerAdd*)



PacletServerAdd//Clear


Options[PacletServerAdd]=
	Options@PacletUpload;
PacletServerAdd[
	server:LocalPacletServerPattern,
	pacletSpecs:pacletUploadPat,
	ops:OptionsPattern[]
	]:=
	PacletUpload[
		pacletSpecs,
		ops,
		Sequence@@
			FilterRules[
				Normal@server,
				Options@PacletUpload
				],
		"UseCachedPaclets"->False,
		"UploadSiteFile"->True
		];
PacletServerAdd[
	k_?(KeyMemberQ[$PacletServers, #]&),
	pacletSpecs:pacletUploadPat,
	ops:OptionsPattern[]
	]:=
	With[{s=
		PacletServerAdd[
			$PacletServers[k],
			pacletSpecs,
			ops
			]
		},
		s/;Head[s]=!=PacletServerAdd
		];
PacletServerAdd[
	s_String?DirectoryQ,
	pacletSpecs:pacletUploadPat,
	ops:OptionsPattern[]
	]:=
	PacletServerAdd[
		{"ServerBase"->s, "ServerName"->Nothing},
		pacletSpecs,
		ops
		]


(* ::Subsubsection::Closed:: *)
(*PacletServerRemove*)



PacletServerRemove//Clear


Options[PacletServerRemove]=
	Options@PacletRemove;
PacletServerRemove[
	server:LocalPacletServerPattern,
	pacletSpecs:$PacletRemovePatterns,
	ops:OptionsPattern[]
	]:=
	PacletRemove[
		pacletSpecs,
		Sequence@@
			FilterRules[
				Flatten@{
					ops,
					"MergePacletInfo"->False,
					Normal@server
					},
				Options@PacletRemove
				]
		];
PacletServerRemove[
	k_?(KeyMemberQ[$PacletServers, #]&),
	pacletSpecs:$PacletRemovePatterns,
	ops:OptionsPattern[]
	]:=
	With[{
		s=
		PacletServerRemove[
			$PacletServers[k],
			pacletSpecs,
			ops
			]
		},
		s/;Head[s]=!=PacletServerRemove
		];
PacletServerRemove[
	s_String?DirectoryQ,
	pacletSpecs:pacletUploadPat,
	ops:OptionsPattern[]
	]:=
	PacletServerRemove[
		{"ServerBase"->s, "ServerName"->Nothing},
		pacletSpecs,
		ops
		]


(* ::Subsubsection::Closed:: *)
(*PacletServerDelete*)



Options[PacletServerDelete]=
	{
		"DeleteLocal"->True,
		"DeleteCloud"->False
		};
PacletServerDelete[
	server:LocalPacletServerPattern,
	ops:OptionsPattern[]
	]:=
	(
		If[OptionValue["DeleteLocal"],
			With[{d=PacletServerDirectory[server]},
				If[DirectoryQ[d],
					DeleteDirectory[PacletServerDirectory[server],
						DeleteContents->True
						]
					]
				]
			];
		If[OptionValue["DeleteCloud"],	
			With[
				{d=
					Quiet@Check[
						CloudObject@PacletServerDeploymentURL[server], 
						$Failed
						]},
				If[MatchQ[d, _CloudObject],
					Quiet[
						DeleteFile/@
							Replace[CloudObjects[d], Except[{__CloudObject}]->{}]
						]
					]
				]
			];
		)
PacletServerDelete[
	k_?(KeyMemberQ[$PacletServers, #]&),
	ops:OptionsPattern[]
	]:=
	PacletServerDelete[$PacletServers[k], ops]


(* ::Subsection:: *)
(*Site*)



(* ::Subsubsection::Closed:: *)
(*PacletMarkdownNotebook Bits*)



pacletMarkdownNotebookDownloadLink[a_]:=
	Cell[
		TextData[
			ButtonBox["Download",
				BaseStyle->"Hyperlink",
					ButtonData->
					{
						URLBuild@{
							"Paclets",
							Lookup[a,"Name"]<>"-"<>
								Lookup[a,"Version"]<>".paclet"
							},
						None
						}
				]
			],
		"Text",
		CellTags->"DownloadLink"
		]


pacletMarkdownNotebookDescriptionText[a_]:=
	Cell[Lookup[a,"Description",""],"Text",
		CellTags->"DescriptionText"
		]


pacletMarkdownNotebookBasicInfoSection[a_,thing_]:=
	With[{d=Lookup[a, thing]},
		If[StringQ@d,
			Cell[
				CellGroupData[{
					Cell[thing," Subsubsection", CellTags->thing],
					Cell[d, "Text"]
					}]
				],
			Nothing
			]
		]


pacletMarkdownNotebookExtensionSection[extensionData_]:=
	Cell[
		CellGroupData@
			Flatten@{
				Cell["Extensions", "Subsection"],
				KeyValueMap[
					Cell@
						CellGroupData[Flatten@{
							Cell[#,"Subsubsection"],
							Replace[
								Replace[Normal@#2,{
									((Prepend|Append)->_):>Nothing,
									{
										(k_->v:Except[{__String}, _List]):>
											Cell[
												CellGroupData[
													Prepend[Cell[ToString[k], "Item"]]@
														Map[
															Cell[
																Replace[#, 
																	{
																		(sk_->sv_):>
																			ToString[sk]<>": "<>ToString[sv],
																		e_:>ToString[e]
																		}
																	], 
																"Subitem"]&,
															v
															]
													]
												],
										(k_->v_):>
											Cell[ToString[k]<>": "<>
												ToString[Replace[v, {str__String}:>StringRiffle[str, ", "]]], "Item"]
										}
									},
									1],
								{}:>Cell["This extension has no extra parameters", "Item"]
								]
							}]&,
					KeyDrop[
						extensionData,
						{"PacletServer"}
						]
					]
				},
		CellTags->"Extensions"
		]


(* ::Subsubsection::Closed:: *)
(*PacletMarkdownNotebook*)



PacletMarkdownNotebook//Clear


PacletMarkdownNotebook[a_Association]:=
	Notebook[
		{
			Cell[
				BoxData@ToBoxes@
					KeyDrop[a, "URL"],
				"Metadata"
				],
			Cell@CellGroupData@
				Flatten@{
					Cell[Lookup[a, "Name", "Unnamed Paclet"],"Section"],
					pacletMarkdownNotebookDownloadLink[a],
					pacletMarkdownNotebookDescriptionText[a],
					Prepend[Cell["","PageBreak"]]@
					Riffle[
						{
							Cell[
								CellGroupData[{
									Cell["Basic Information","Subsection"],
									pacletMarkdownNotebookBasicInfoSection[a,"Name"],
									pacletMarkdownNotebookBasicInfoSection[a,"Version"],
									pacletMarkdownNotebookBasicInfoSection[a,"Description"],
									pacletMarkdownNotebookBasicInfoSection[a,"Creator"]
									}],
								CellTags->"BasicInformation"
								],
							If[KeyMemberQ[a, "Extensions"],
								pacletMarkdownNotebookExtensionSection[a["Extensions"]],
								Nothing
								]
							},
					Cell["","PageBreak"]
					]
				}
			},
		StyleDefinitions->FrontEnd`FileName[Evaluate@{$PackageName,"MarkdownNotebook.nb"}]
		];
PacletMarkdownNotebook[p_PacletManager`Paclet]:=
	With[{a=PacletInfoAssociation@p},
		PacletMarkdownNotebook[
			Join[
				a, 
				Association@
					Fold[
						Lookup[#, #2, <||>]&,
						a,
						{"Extensions", "PacletServer"}
						]
				]
			]
		];
PacletMarkdownNotebook[f_String?FileExistsQ,a_,regen_:Automatic]:=
	PacletMarkdownNotebookUpdate[f,a,regen];
PacletMarkdownNotebook[f_String, a_, regen_:Automatic]:=
	With[{nb=PacletMarkdownNotebook[a]},
		Switch[nb,
			_Notebook,
				If[!DirectoryQ@DirectoryName@f,
					CreateDirectory[DirectoryName@f,
						CreateIntermediateDirectories->True
						]
					];
				If[FileExistsQ@f,
					If[TrueQ[regen]||Import[f]=!=nb,
						Export[f,nb]
						],
					Export[f,nb]
					],
			_,
				$Failed
			]
		]


(* ::Subsubsection::Closed:: *)
(*PacletMarkdownNotebookUpdate*)



$killFields=
	{
		"Name","Version","BuildNumber",
		"Qualifier","WolframVersion",
		"SystemID","Description","Category",
		"Creator","Publisher","Support",
		"Internal","Location"
		};


PacletMarkdownNotebookUpdate//Clear


PacletMarkdownNotebookUpdate[notebook_Notebook,a_]:=
	Module[{nb=notebook},
		nb=
			ReplaceAll[nb,
				Cell[BoxData[e_],"Metadata",___]:>
					Cell[
						BoxData@ToBoxes@
							Merge[{KeyDrop[ToExpression[e], $killFields], a},Last],
						"Metadata"
						]
				];
		nb=
			ReplaceAll[nb,
				Cell[___,CellTags->"DownloadLink",___]:>
					pacletMarkdownNotebookDownloadLink[a]
				];
		nb=
			ReplaceAll[nb,
				Cell[___,CellTags->"DescriptionText",___]:>
					pacletMarkdownNotebookDescriptionText[a]
				];
		Map[
			Function[
				nb=	
					ReplaceAll[nb,
						Cell[
							CellGroupData[{
								Cell[___,
									CellTags->#,
									___
									],
								___
								},
								___],
							___
							]:>
								pacletMarkdownNotebookBasicInfoSection[a,#]
						]
				],
			DeleteCases[Keys[a],
				"Extensions"|"Tags"|"Categories"|"Authors"
				]
			];
		nb=
			DeleteCases[nb,
				Cell[
					CellGroupData[{
						Cell[___,
							CellTags->
								Except[
									Alternatives@@
										Join[{
											"DescriptionText",
											"DownloadLink",
											"BasicInformation"
											},
											Keys[a]
											]
									],
							___
							],
						___
						},___],
					___
					],
				\[Infinity]
				];
		nb=
			ReplaceAll[nb,
				Cell[
					CellGroupData[{
						Cell[___,
							CellTags->"Extensions",
							___]
						},___
						],
					___
					]:>
					pacletMarkdownNotebookExtensionSection[a["Extensions"]]
				];
		nb
		];
PacletMarkdownNotebookUpdate[f_String?FileExistsQ,a_,regen_:Automatic]:=
	With[{nb=Import[f]},
		Switch[nb,
			_Notebook,
				With[{new=PacletMarkdownNotebookUpdate[nb,a]},
					If[TrueQ[regen]||new=!=nb,
						Export[
							f,
							PacletMarkdownNotebookUpdate[nb,a]
							]
						]
					],
			_,
				$Failed
			]
		]


(* ::Subsubsection::Closed:: *)
(*PacletServerInitialize*)



PacletServerInitialized[server_]:=
	With[{d=PacletServerDirectory[server]},
		AllTrue[{d,
			FileNameJoin@{d,"content"},
			FileNameJoin@{d,"SiteConfig.wl"}
			},
			FileExistsQ
			]
		];
$PacletServerInitialized:=
	PacletServerInitialized@$PacletServer


PacletServerInitialize//Clear


PacletServerInitialize[server:localPacletServerPatOrDir]:=
	If[!PacletServerInitialized@server,
		With[{d=PacletServerDirectory@server},
			If[!DirectoryQ@d,	
				CreateDirectory[d, CreateIntermediateDirectories->True]
				];
			With[{tempDir=PackageFilePath["Resources","Templates","PacletServer"]},
				Map[
					With[
						{
							tf=FileNameJoin@{d,FileNameDrop[#,FileNameDepth[tempDir]]}
							},
						If[!FileExistsQ@tf,
							If[DirectoryQ@#,
								CopyDirectory[#, tf],
								CopyFile[#, tf]
								]
							]
						]&,
					FileNames["*", tempDir, \[Infinity]]
					];
				]
			]
		]


(* ::Subsubsection::Closed:: *)
(*PacletServerBuild*)



Options[PacletServerBuild]=
	Join[
		Options[WebSiteBuild],
		{
			"RegenerateContent"->Automatic,
			"BuildSite"->True
			}
		];
PacletServerBuild[
	server:localPacletServerPatOrDir,
	ops:OptionsPattern[]
	]:=
	With[
		{
			siteData=
				PacletServerExposedPaclets[server]
			},
		PacletServerInitialize[server];
		If[MatchQ[OptionValue["RegenerateContent"], True|Automatic],
			If[OptionValue[Monitor],
				Function[Null,
					Monitor[#, 
						Internal`LoadingPanel[TemplateApply["Generating ``", md]]
						],
					HoldAll
					],
				Identity
				]@
				Block[{md},
					With[{nbout=PacletServerFile[server, {"content","posts",#Name<>".nb"}]},
						md=nbout;
						PacletMarkdownNotebook[
							nbout,
							Join[
								<|
									"Title"->Lookup[#,"Name","Unnamed Paclet"],
									"Categories"->"misc",
									"Slug"->Automatic,
									"Authors"->
										StringTrim@
											Map[
												StringSplit[#, "@"|"<"][[1]]&,
												StringSplit[Lookup[#,"Creator",""], ","]
												],
									"Tags"->StringSplit[Lookup[#,"Keywords",""],","]
									|>,
								#
								]
							];
							Function[NotebookMarkdownSave[#];NotebookClose[#]]@
								NotebookOpen[nbout,Visible->False];
							]&/@Association/@siteData
						]
			];
		With[{s=
			If[TrueQ@OptionValue["BuildSite"],
				WebSiteBuild[
					PacletServerDirectory[server],
					"AutoDeploy"->False,	
					"Configuration"->
						With[
							{
								conf=
									Replace[
										Quiet@Import@
											If[FileExistsQ@PacletServerFile[server, "SiteConfig.m"],
												PacletServerFile[server, "SiteConfig.m"],
												PacletServerFile[server, "SiteConfig.wl"]
												],
										{
											o_?OptionQ:>
												Association[o],
											_-><||>
											}
										]
								},
							If[StringQ@server,
								conf,
								Join[
									<|
										"SiteName"->
											Lookup[server, "ServerName"],
										"SiteURL"->
											With[
												{
													cc=
														PacletServerDeploymentURL[server]
													},
												cc
												],
										"Theme"->
											"PacletServer",
										CloudConnect->
											server[CloudConnect],
										Permissions->
											server[Permissions]
										|>,
									conf
									]
								]
							],
					Sequence@@
						FilterRules[
							FilterRules[
							{
								ops,
								"OutputDirectory"->
									If[GitRepoQ@PacletServerDirectory[server],
										"docs",
										Automatic
										]
								},
								Options@WebSiteBuild
								],
							Except["AutoDeploy"]
							]
					],
				Quiet@CreateDirectory@
					PacletServerFile[
						server,
						If[GitRepoQ@PacletServerDirectory[server],
							 "output",
							 "docs"
								]
						];
				PacletServerFile[
						server,
						If[GitRepoQ@PacletServerDirectory[server],
							 "output",
							 "docs"
								]
						]
				]
			},
			If[TrueQ[OptionValue["AutoDeploy"]]||
				TrueQ@
					OptionValue["AutoDeploy"]===Automatic&&
						Lookup[
							Replace[Quiet@Import[PacletServerFile[server, "SiteConfig.wl"]],
								Except[_Association]:>{}
								],
							"AutoDeploy"
							],
				PacletServerDeploy[
					server,
					Replace[
						OptionValue["DeployOptions"],
						Except[_?OptionQ]->{}
						]
					],
				s
				]
			]
		];
PacletServerBuild[
	k_?(KeyMemberQ[$PacletServers, #]&),
	ops:OptionsPattern[]
	]:=
	PacletServerBuild[$PacletServers[k], ops]


(* ::Subsubsection::Closed:: *)
(*PacletServerDeploy*)



PacletServerDeploy//Clear


PacletServerDeploy::nobld=
	"PacletServerBuild needs to be called before PacletServerDeploy can work";


Options[PacletServerDeploy]=
	Join[
		Options[WebSiteDeploy],
		{
			"DeployPages"->True
			}
		];
PacletServerDeploy[
	server:LocalPacletServerPattern,
	ops:OptionsPattern[]
	]:=
	With[
		{
			outDir=
				Replace[OptionValue["OutputDirectory"],
						{
							Automatic:>
								PacletServerFile[server, "output"],
							s_String?(Not@*DirectoryQ):>
								PacletServerFile[server, s]
							}
						]
			},
		If[
			DirectoryQ@PacletServerFile[server, "Paclets"]||
				DirectoryQ@outDir,
			With[
				{
					baseConfig=
						Lookup[
							Replace[Quiet@Import[PacletServerFile[server, "SiteConfig.wl"]],
								Except[_?OptionQ]:>{}
								],
							"DeployOptions",
							{}
							]
					},
					If[!DirectoryQ@#,
						CreateDirectory@#
						]&@outDir;
					WebSiteDeploy[
						outDir,
						Lookup[server, "ServerName"],
						FilterRules[
							Normal@
								Merge[
									{
										ops,
										CloudConnect->
											Lookup[server, CloudConnect],
										Permissions->
											Lookup[server, Permissions],
										baseConfig,
										"ServerTheme"->
											"PacletServer",
										"ExtraFileNameForms"->
											{
												"PacletSite.mz",
												"*.paclet"
												},
										"IncludeFiles"->
											{
												PacletServerFile[server, "PacletSite.mz"],
												PacletServerFile[server, "Paclets"]
												},
										"OutputDirectory"->
											If[GitRepoQ@PacletServerDirectory[server],
												"docs",
												Automatic
												]
											},
									Replace[
										{
											{s:_String|_?OptionQ|_?AtomQ,___}:>s,
											e_:>Flatten@e
											}
										]
									],
							Options@WebSiteDeploy
							]
						]
				],
			Message[PacletServerDeploy::nobld];
			$Failed
			]
		];
PacletServerDeploy[
	k_?(KeyMemberQ[$PacletServers, #]&),
	ops:OptionsPattern[]
	]:=
	PacletServerDeploy[$PacletServers[k], ops]


(* ::Subsection:: *)
(*Git*)



(* ::Subsubsection::Closed:: *)
(*PacletServerGitHubRepoExists*)



PacletServerGitHubRepoExistsQ[server_]:=
	With[{repo=PacletServerGitHubRepo[server]},
		Between[URLRead[repo,"StatusCode"], {200,299}]
		]


(* ::Subsubsection::Closed:: *)
(*PacletServerGitHubRepo*)



PacletServerGitHubRepo[server_, password_:None]:=
	Replace[
		Replace[
			Lookup[server, "GitHubRepo"],
			Except[_String?(StringLength[#]>0&)]:>
				Lookup[server, "ServerName"]
			],
		s_String:>
			URL@
				GitHubPath[
					s,
					"Password"->password
					]
		]


(* ::Subsubsection::Closed:: *)
(*PacletServerGitHubConfigure*)



$PacletServerDefaultREADMEText="
### Paclet Server 

## About

This is a Mathematica paclet server.

It hosts paclets that can be installed directly into Mathematica.

## Installation:

To install a paclet, use the following:

    PacletInstall[\"paclet_name\",
     \"Site\"->\"http://raw.githubusercontent.com/<user_name>/<repo_name>\"
     ]

To update a paclet, use the following:

    PacletUpdate[\"paclet_name\",
     \"Site\"->\"http://raw.githubusercontent.com/<user_name>/<repo_name>\"
     ]

";


$PacletServerREADMEText:=
	$PacletServerREADMEText=
		Replace[
			Quiet@
				Import[
					PackageFilePath["Resources", "Templates", "PacletServer-README.md"],
					"Text"
					],
			Except[_String]->
				$PacletServerDefaultREADMEText
			];


PacletServerGitHubConfigure[server_]:=
	(
		If[!FileExistsQ@PacletServerFile[server, "README.md"],
			Export[PacletServerFile[server, "README.md"],
				$PacletServerREADMEText,
				"Text"
				]
			];
		GitHub["Configure",
			PacletServerDirectory[server],
			PacletServerGitHubRepo[server],
			{".DS_Store"},
			{"content"}
			]
		)


(* ::Subsubsection::Closed:: *)
(*PacletServerGitHubPush*)



PacletServerGitHubPush[server_]:=
	With[{dir=PacletServerDirectory[server]},
		Git["Add", dir, "-A"];
		Git["Commit", dir, 
			Message->
				TemplateApply[
					"Committed paclet server @ ``",
					StringReplace[
						DateString["ISODateTime"],
						"T"->"_"
						]
					]
			];
		GitHubImport["Push", dir]
		]


End[];



