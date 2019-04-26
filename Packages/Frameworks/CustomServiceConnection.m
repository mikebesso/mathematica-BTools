(* ::Package:: *)

(* Autogenerated Package *)

CustomServiceConnection::usage="Builds a custom ServiceConnection paclet"


Begin["`Private`"];


(* ::Subsection:: *)
(*Setup*)



(* ::Subsubsection::Closed:: *)
(*Import Functions*)



CustomServiceConnection::ifkey="Import function `` missing keys ``";


Options[customServiceConnectionImportFunction]:=
  {
    "URL"->None,
    "Method"->"GET",
    "Body"->None,
    "Headers"->None,
    "Path"->None,
    "Parameters"->None,
    "Required"->None,
    "Function"->None,
    "Permissions"->None,
    "ReturnContentData"->None,
    "RequiredPermissions"->None,
    "IncludeAuth"->None,
    "MultipartData"->None,
    "BodyData"->None
    };
customServiceConnectionImportFunction[name_,ops:OptionsPattern[]]:=
  With[
    {
      basic=
        DeleteCases[None]@
          Association@{ops},
      required=
        {"URL","Path"}
      },
    With[{
      function=
        Join[
          DeleteCases[{}]@
            <|
              "BodyData"->
                Cases[Lookup[basic,"Body",{}],_String|_Rule],
              "MultipartData"->
                Cases[Lookup[basic,"Body",{}],_List]
              |>,
          KeyDrop[
            KeyMap[
              Replace[{
                "Method"->"HTTPSMethod",
                "Path"->"PathParameters",
                "Required"->"RequiredParameters",
                "Function"->"ResultsFunction",
                "Permissions"->"RequiredPermisssions"
                }],
              If[!(KeyMemberQ[basic,"Method"]&&KeyMemberQ[basic,"HTTPSMethod"]),
                Append["Method"->OptionValue["Method"]],
                Identity
                ]@basic
              ],
            "Body"
            ]
          ]
      },
      Replace[
        Select[MissingQ]@
          Lookup[function,AssociationThread[required,required]],{
          a_?(Length@#>0&):>
            (
              Message[CustomServiceConnection::ifkey,name,Keys@a];
              $Failed
              ),
          _:>
            (name->Normal@function)
        }]
      ]
    ]


(* ::Subsubsection::Closed:: *)
(*Prep Functions*)



CustomServiceConnection::pfkey="Process function `` missing keys ``";


Options[customServiceConnectionProcessFunction]={
  "Call"->None,
  "Method"->None,
  "CleanArguments"->None,
  "Pre"->None,
  "Import"->None,
  "Post"->None,
  "Default"->None,
  "Parameters"->None,
  "Required"->None
  };
customServiceConnectionProcessFunction[name_,ops:OptionsPattern[]]:=
  With[
    {
      function=
        DeleteCases[None]@
          Association@{ops},
      required=
        {}
      },
    Replace[
      Select[MissingQ]@
        Lookup[function,AssociationThread[required,required]],{
        a_?(Length@#>0&):>
          (
            Message[CustomServiceConnection::pfkey,name,Keys@a];
            $Failed
            ),
        _:>
          (name->function)
      }]
    ];
  customServiceConnectionProcessFunction[name_,func_]:=
    customServiceConnectionProcessFunction[name,
      "Call"->"Raw"<>name,
      "Import"->func
      ]


(* ::Subsubsection::Closed:: *)
(*Template*)



$customServiceExportContext=$Context;


customServiceTemplateExport[
  name_,
  dir_,
  template_,
  params_
  ]:=
  Module[
    {
      tf,
      out,
      pars,
      body,
      templateBody
      },
    tf=
      PackageFilePath[
        "Resources",
        "Templates",
        "Frameworks",
        "$ServiceConnection",
        "Kernel",
        template<>".m"
        ];
    out=
      FileNameJoin@{
        dir,
        "ServiceConnection_"<>name,
        "Kernel",
        StringReplace[
          template,
          "$ServiceConnection"->
            name
          ]<>".m"
        };
    If[!FileExistsQ@tf,
      PackageRaiseException[
        Automatic,
        "Couldn't locate template file ``",
        template
        ]
      ];
    pars=
      Internal`WithLocalSettings[
        cachedSettings["Context"]=$Context;
        cachedSettings["ContextPath"]=$ContextPath;
        $Context=$customServiceExportContext;
        $ContextPath=
          Join[
            {"System`", $customServiceExportContext},
            Select[$ContextPath, 
              StringStartsQ["Global`"|"Notebook$$"|"Cell$$"]
              ]
            ],
        With[{obj=#2,key=#},
            #->
              Switch[obj,
                Verbatim[Verbatim][_String],
                  First@obj,
                _Function,
                  "("<>ToString[#2,InputForm]<>")",
                _,
                  If[(ListQ@obj||AssociationQ@obj)&&Length@obj>0,
                    Replace[
                      NewlineateCodeRecursive[
                        obj,
                        _List|_Association|_Rule
                        ],
                      {
                        RawBoxes[r_]:>
                        "\n"<>BoxesToString[r],
                        e_:>(ToString[obj,InputForm])
                      }
                      ],
                    ToString[obj,InputForm]
                    ]
                ]
            ]&@@@params,
        $Context=cachedSettings["Context"];
        $ContextPath=cachedSettings["ContextPath"];
        cachedSettings//Clear
        ];
    Replace[pars,
      (k_->e:Except[_String]):>
        PackageRaiseException[
          Automatic,
          "Failed to convert parameter `` to string",
          k
          ],
      1
      ];
    templateBody=Import[tf, "Text"];
    body=StringReplace[templateBody, pars];
    If[templateBody==body,
      PackageRaiseException[
        Automatic,
        "Failed to export service connection file `` for connection ``",
        StringReplace[
          template,
          "$ServiceConnection"->
            name
          ],
        name
        ]
      ];
    Export[out, body, "Text"];
    If[!FileExistsQ@out,
      PackageRaiseException[
        Automatic,
        "Failed to export service connection file `` for connection ``",
        StringReplace[
          template,
          "$ServiceConnection"->
            name
          ],
        name
        ]
      ];
    out
    ];


(* ::Subsubsection::Closed:: *)
(*Base Functions*)



$customServiceConnectionBaseFetchFunction=
  (
      With[ {params = Lookup[{##2},"Parameters",{}]},
        URLFetch[#1,
          Sequence@@FilterRules[{##2},Except["Parameters"]],
            "Parameters" -> 
              FilterRules[params, 
                  Except[{"accountid", "authtoken"}]
                  ],
            "Username"->"accountid"/.params,
            "Password"->"authtoken"/.params
            ]
        ]&
      )


(* ::Subsubsection::Closed:: *)
(*customServiceConnectionPrep*)



Options[customServiceConnectionPrep]={
  "Fetch"->
    Automatic,
  "Client"->
    Automatic,
  "ClientInfo"->
    Automatic,
  "ClientID"->None,
  "ClientSecret"->None,
  "AuthorizationResponseType"->None,
  "RedirectURI"->None,
  "AuthorizationState"->None,
  "AuthorizationScope"->None,
  "LoginURL"->
    None,
  "LogoutURL"->
    None,
  "UseOAuth"->
    Automatic,
  "AuthorizeEndpoint"->
    Automatic,
  "AccessEndpoint"->
    Automatic,
  "TokenRequestor"->
    None,
  "TokenExtractor"->
    None,
  "TermsOfServiceURL"->
    None,
  "Information"->
    None,
  "Thumbnail"->
    None,
  "Functions"->
    None
  };
customServiceConnectionPrep[
  name_,
  dir_,
  functionData:_List?OptionQ,
  cookingData:_List?OptionQ,
  ops:OptionsPattern[]
  ]:=
  With[{
    imps=
      Association[customServiceConnectionImportFunction@@@functionData],
    preps=
      Association[customServiceConnectionProcessFunction@@@cookingData]
    },
    With[{
      params=
      Flatten@{
        "$ServiceConnectionURLFetch"->
          OptionValue@"Fetch",
        "$ServiceConnectionClientInfo"->
          OptionValue@"ClientInfo",
        "$ServiceConnectionClientName"->
          StringReplace[
            Replace[
              HoldPattern[Capitalize[s_String]]:>
                (ToUpperCase@StringTake[s,1]<>StringDrop[s,1])
              ]@Capitalize@ToLowerCase@
              StringTrim[
                Replace[OptionValue@"Client",{
                  Automatic:>
                    If[
                      Replace[OptionValue@"UseOAuth",
                        Except[True|False]:>
                          !MatchQ[OptionValue["AuthorizeEndpoint"],Automatic|None]&&
                            !MatchQ[OptionValue["AccessEndpoint"],Automatic|None]
                        ]//TrueQ,
                      "OAuth",
                      "Key"
                      ],
                  Except[_String]->"Key"
                  }],
                "client"
                ]<>"Client",
            "Oauth"->"OAuth"
            ],
        "$ServiceConnectionUseOAuth"->
          Replace[OptionValue@"UseOAuth",
            Except[True|False]:>
              StringQ@OptionValue@"Client"&&
                StringStartsQ[ToLowerCase@OptionValue@"Client","oauth"]||
              !MatchQ[OptionValue["AuthorizeEndpoint"],Automatic|None]&&
                !MatchQ[OptionValue["AccessEndpoint"],Automatic|None]
            ],
        "$ServiceConnectionAuthEndpoint"->
          Replace[OptionValue@"AuthorizeEndpoint",
            Automatic:>
              If[
                TrueQ[
                  TrueQ@OptionValue@"UseOAuth"||
                    StringQ@OptionValue@"Client"&&
                      StringStartsQ[ToLowerCase@OptionValue@"Client","oauth"]
                  ],
                "https://localhost:8080/oauth2authorize",
                None
                ]
              ],
        "$ServiceConnectionAccessEndpoint"->
          Replace[OptionValue@"AccessEndpoint",
            Automatic:>
              If[
                TrueQ[
                  TrueQ@OptionValue@"UseOAuth"||
                    StringQ@OptionValue@"Client"&&
                      StringStartsQ[ToLowerCase@OptionValue@"Client","oauth"]
                  ],
                "https://localhost:8080/oauth2access",
                None
                ]
              ],
        "$ServiceConnectionAccessTokenRequestor"->
          OptionValue@"TokenRequestor",
        "$ServiceConnectionAccessTokenExtractor"->
          OptionValue@"TokenExtractor",
        "$ServiceConnectionTermsOfServiceURL"->
          OptionValue@"TermsOfServiceURL",
        "$ServiceConnectionClientID"->
          OptionValue@"ClientID",
        "$ServiceConnectionClientSecret"->
          OptionValue@"ClientSecret",
        "$ServiceConnectionAuthResponseType"->
          OptionValue@"AuthorizationResponseType",
        "$ServiceConnectionState"->
          OptionValue@"AuthorizationState",
        "$ServiceConnectionAuthScope"->
          OptionValue@"AuthorizationScope",
        "$ServiceConnectionRedirectURI"->
          Replace[OptionValue@"RedirectURI",
            Automatic:>
              If[OptionValue@"UseOAuth"||
                StringQ@OptionValue@"Client"&&
                  StringStartsQ[ToLowerCase@OptionValue@"Client","oauth"],
                "https://localhost:7000/oauth2callback",
                None
                ]
              ],
        "$ServiceConnectionCalls"->
          imps,
        "$ServiceConnectionCookingFunctions"->
          preps,
          With[{r=#,b=ToUpperCase@StringTrim[#,"s"]},
            With[{
              impSpec=
                Cases[Normal@imps,
                  (k_->{
                    ___,
                    "HTTPSMethod"->_?(
                      (ToUpperCase@#/.("PATCH"|"PUT"|"DELETE"->"POST"))===b&),
                    ___
                    }):>k
                  ]
              },
            Sequence@@
              {
                "$ServiceConnectionRaw"<>r->
                  impSpec,
                "$ServiceConnection"<>r->
                  Join[
                    Keys@
                      Select[preps,
                        If[KeyMemberQ[#,"Method"],
                          ReplaceAll[
                            ToUpperCase@#["Method"],
                            "PATCH"|"PUT"|"DELETE"->"POST"
                            ]===ToUpperCase@StringTrim[r,"s"],
                          MemberQ[impSpec,#["Call"]]
                          ]&
                        ],
                    If[r==="Gets",
                      Keys@
                        Select[preps,
                          AllTrue[
                            Lookup[#,{"Call","Method"}],
                            MissingQ
                            ]&
                          ],
                      {}
                      ]
                    ]
                }
            ]
          ]&/@{"Gets","Posts"},
        "$ServiceConnectionInformation"->
          OptionValue@"Information",
        "$ServiceConnectionIcon"->
          OptionValue@"Thumbnail",
        "$ServiceConnectionHelperNames"->
          Verbatim@
            StringRiffle[
              Replace[
                Flatten@DeleteCases[None]@{OptionValue@"Functions"},{
                (k_->f_):>
                  ToString[k],
                e_:>
                  ToString@e
                },
                1],
              "\n\n"
              ],
        "$ServiceConnectionHelperFunctions"->
          Block[{$ContextPath={"System`",$Context}},
            Verbatim@
              StringRiffle[
                Replace[
                  Flatten@DeleteCases[None]@{OptionValue@"Functions"},{
                  (k_->f_):>
                    (ToString[k]<>" = "<>ToString[f,InputForm]),
                  e_:>
                    ToString[Definition@e,InputForm]
                  },
                  1],
                "\n\n"
                ]
            ],
        "$ServiceConnection"->
          Verbatim@name,
        "$serviceconnection"->
          Verbatim@ToLowerCase@name
        }
      },
    customServiceTemplateExport[
      name,
      dir,
      #,
      params
      ]&/@{
        "load",
        "$ServiceConnection",
        "$ServiceConnectionFunctions",
        "$ServiceConnectionLoad"
        }
      ]
    ]


(* ::Subsubsection::Closed:: *)
(*customServiceBitmapsExport*)



customServiceBitmapsExport[dir_, name_, things_]:=
  Module[
    {
      bmdir
      },
    bmdir=
      FileNameJoin@{
          dir,
          "ServiceConnection_"<>name,
          "FrontEnd",
          "SystemResources",
          "Bitmaps"
        };
    Quiet@CreateDirectory[bmdir, CreateIntermediateDirectories->True];
    If[MatchQ[First@things,(_File|_String)?FileExistsQ],
      CopyFile[
        First@things,
        FileNameJoin@{
          bmdir,
          ToLowerCase@name<>".png"
          }
        ],
      Export[
        FileNameJoin@{
          bmdir,
          ToLowerCase@name<>".png"
          },
        First@things
        ]
      ];
    If[MatchQ[Last@things,(_File|_String)?FileExistsQ],
      CopyFile[
        Last@things,
        FileNameJoin@{
          bmdir,
          ToLowerCase@name<>"@2.png"
          }
        ],
      Export[
        FileNameJoin@{
          bmdir,
          ToLowerCase@name<>"@2.png"
          },
        Last@things
        ]
      ]
    ]


(* ::Subsubsection::Closed:: *)
(*customServicePacletExport*)



customServicePacletExport[dir_, name_, ops:OptionsPattern[]]:=
  Module[
    {
      bundle
      },
    bundle=
      PacletInfoExpressionBundle[
        FileNameJoin@{dir,"ServiceConnection_"<>name},
        FilterRules[
          Flatten@{
            FilterRules[{ops}, Except["Thumbnail"]],
            "Thumbnail"->
              FileNameJoin@{
                  "FrontEnd",
                  "SystemResources",
                  "Bitmaps",
                  ToLowerCase@name<>"@2.png"
                  }
              },
            Options@PacletInfoExpressionBundle
            ]
          ];
      If[!PacletManager`VerifyPaclet@bundle,
        PackageRaiseException[
          Automatic,
          "Couldn't make PacletInfo.m for connection ``",
          name
          ]
        ];
      PacletBundle@FileNameJoin@{dir, "ServiceConnection_"<>name}
      ]


(* ::Subsubsection::Closed:: *)
(*customServicePostProcess*)



customServicePostProcess[
  dir_, name_, 
  iconList_,
  pack_,
  ops:OptionsPattern[]
  ]:=
  Module[
    {
      icons
      },
    icons=
      Replace[iconList,
        {
          g_Graphics:>
            {
              Insert[g,
                ImageSize->24,
                2
                ],
              Insert[g,
                ImageSize->48,
                2
                ]
              },
          i_?ImageQ:>
            {
              ImageResize[i,{24}],
              ImageResize[i,{48}]
              },
          e:Except[None|{_,_}]:>
            {
              Rasterize[e,"Image",
                RasterSize->{24,24}],
              Rasterize[e,"Image",
                RasterSize->{48,48}]
              }
          }
        ];
    If[ListQ@icons&&Length@icons==2,
      customServiceBitmapsExport[dir, name, icons]
      ];
    If[pack,
      customServicePacletExport[dir, name, ops],
      FileNameJoin@{dir,"ServiceConnection_"<>name}
      ]
    ]


(* ::Subsubsection::Closed:: *)
(*CustomServiceConnection*)



CustomServiceConnection//Clear


Options[CustomServiceConnection]=
  Join[
    {
      "ImportFunctions"->{},
      "ProcessFunctions"->{},
      "Thumbnail"->None
      },
    Options@customServiceConnectionPrep,
    Options@PacletInfoExpressionBundle
    ];


(* ::Subsubsubsection::Closed:: *)
(*iCustomServiceConnection*)



Options[iCustomServiceConnection]=
  Options[CustomServiceConnection];
iCustomServiceConnection[
  name_String?(StringMatchQ[WordCharacter..]),
  directory:_String?DirectoryQ|Automatic:Automatic,
  pack:True|False:True,
  ops:OptionsPattern[]
  ]:=
  Module[
    {
      dir,
      res,
      out
      },
    dir=Replace[directory, Automatic:>$TemporaryDirectory];
    Quiet@
      CreateDirectory[
        FileNameJoin@
          {
            dir,
            "ServiceConnection_"<>name,
            "Kernel"
            },
        CreateIntermediateDirectories->True
        ];
    res=
      customServiceConnectionPrep[
        name,
        dir,
        OptionValue@"ImportFunctions",
        OptionValue@"ProcessFunctions",
        FilterRules[
          {
            "Thumbnail"->
              Replace[OptionValue@"Thumbnail",
                {
                  Graphics[e_,o___]:>
                    Graphics[e,ImageSize->24,o],
                  Except[None|_Graphics|_?ImageQ]->Automatic
                  }
                ],
              ops
            },
          Options@customServiceConnectionPrep
          ]
        ];
    If[!(ListQ@res&&AllTrue[res, StringQ@#&&FileExistsQ@#&]),
      PackageRaiseException[
        Automatic,
        "Generated service connection files `` invalid",
        res
        ]
      ];
    out=
      customServicePostProcess[
        dir,
        name,
        OptionValue["Thumbnail"],
        pack,
        ops
        ];
    If[!FileExistsQ@out,
      PackageRaiseException[
        Automatic,
        "Generated service connection `` invalid",
        out
        ]
      ];
    out
    ]


(* ::Subsubsubsection::Closed:: *)
(*CustomServiceConnection*)



CustomServiceConnection[
  name_String?(StringMatchQ[WordCharacter..]),
  directory:_String?DirectoryQ|Automatic:Automatic,
  pack:True|False:True,
  ops:OptionsPattern[]
  ]:=
  PackageExceptionBlock["CustomServiceConnection"]@
    iCustomServiceConnection[name, directory, pack, ops]


End[];



