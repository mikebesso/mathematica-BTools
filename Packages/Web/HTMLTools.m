(* ::Package:: *)



CSSGenerate::usage=
  "Takes a list of rules and creates a CSS block";


Begin["`Private`"];


(* ::Subsubsection::Closed:: *)
(*CSSGenerate*)



(* ::Subsubsubsection::Closed:: *)
(*AllowedProperties*)



$CSSDefaultAllowedProperties=
  Alternatives@@
    {
      "align-content","align-items","align-self",
      "all","animation","animation-delay",
      "animation-direction","animation-duration","animation-fill-mode",
      "animation-iteration-count","animation-name","animation-play-state",
      "animation-timing-function","backface-visibility","background",
      "background-attachment","background-blend-mode","background-clip",
      "background-color","background-image","background-origin",
      "background-position","background-repeat","background-size",
      "border","border-bottom","border-bottom-color",
      "border-bottom-left-radius","border-bottom-right-radius","border-bottom-style",
      "border-bottom-width","border-collapse","border-color",
      "border-image","border-image-outset","border-image-repeat",
      "border-image-slice","border-image-source","border-image-width",
      "border-left","border-left-color","border-left-style",
      "border-left-width","border-radius","border-right",
      "border-right-color","border-right-style","border-right-width",
      "border-spacing","border-style","border-top",
      "border-top-color","border-top-left-radius","border-top-right-radius",
      "border-top-style","border-top-width","border-width",
      "bottom","box-shadow","box-sizing",
      "caption-side","clear","clip",
      "color","column-count","column-fill",
      "column-gap","column-rule","column-rule-color",
      "column-rule-style","column-rule-width","column-span",
      "column-width","columns","content",
      "counter-increment","counter-reset","cursor",
      "direction","display","empty-cells",
      "filter","flex","flex-basis",
      "flex-direction","flex-flow","flex-grow",
      "flex-shrink","flex-wrap","float",
      "font","@font-face","font-family",
      "font-size","font-size-adjust","font-stretch",
      "font-style","font-variant","font-weight",
      "hanging-punctuation","height","justify-content",
      "@keyframes","left","letter-spacing",
      "line-height","list-style","list-style-image",
      "list-style-position","list-style-type","margin",
      "margin-bottom","margin-left","margin-right",
      "margin-top","max-height","max-width",
      "@media","min-height","min-width",
      "nav-down","nav-index","nav-left",
      "nav-right","nav-up","opacity",
      "order","outline","outline-color",
      "outline-offset","outline-style","outline-width",
      "overflow","overflow-x","overflow-y",
      "padding","padding-bottom","padding-left",
      "padding-right","padding-top","page-break-after",
      "page-break-before","page-break-inside","perspective",
      "perspective-origin","position","quotes",
      "resize","right","tab-size",
      "table-layout","text-align","text-align-last",
      "text-decoration","text-decoration-color","text-decoration-line",
      "text-decoration-style","text-indent","text-justify",
      "text-overflow","text-shadow","text-transform",
      "top","transform","transform-origin",
      "transform-style","transition","transition-delay",
      "transition-duration","transition-property","transition-timing-function",
      "unicode-bidi","user-select","vertical-align",
      "visibility","white-space","width",
      "word-break","word-spacing","word-wrap",
      "z-index","color","opacity",
      "background","background-attachment","background-blend-mode",
      "background-color","background-image","background-position",
      "background-repeat","background-clip","background-origin",
      "background-size","border","border-bottom",
      "border-bottom-color","border-bottom-left-radius","border-bottom-right-radius",
      "border-bottom-style","border-bottom-width","border-color",
      "border-image","border-image-outset","border-image-repeat",
      "border-image-slice","border-image-source","border-image-width",
      "border-left","border-left-color","border-left-style",
      "border-left-width","border-radius","border-right",
      "border-right-color","border-right-style","border-right-width",
      "border-style","border-top","border-top-color",
      "border-top-left-radius","border-top-right-radius","border-top-style",
      "border-top-width","border-width","box-shadow",
      "bottom","clear","clip",
      "display","float","height",
      "left","margin","margin-bottom",
      "margin-left","margin-right","margin-top",
      "max-height","max-width","min-height",
      "min-width","overflow","overflow-x",
      "overflow-y","padding","padding-bottom",
      "padding-left","padding-right","padding-top",
      "position","right","top",
      "visibility","width","vertical-align",
      "z-index","align-content","align-items",
      "align-self","flex","flex-basis",
      "flex-direction","flex-flow","flex-grow",
      "flex-shrink","flex-wrap","justify-content",
      "order","hanging-punctuation","letter-spacing",
      "line-height","tab-size","text-align",
      "text-align-last","text-indent","text-justify",
      "text-transform","white-space","word-break",
      "word-spacing","word-wrap","text-decoration",
      "text-decoration-color","text-decoration-line","text-decoration-style",
      "text-shadow","@font-face","font",
      "font-family","font-size","font-size-adjust",
      "font-stretch","font-style","font-variant",
      "font-weight","direction","unicode-bidi",
      "direction","user-select","border-collapse",
      "border-spacing","caption-side","empty-cells",
      "table-layout","counter-increment","counter-reset",
      "list-style","list-style-image","list-style-position",
      "list-style-type","@keyframes","animation",
      "animation-delay","animation-direction","animation-duration",
      "animation-fill-mode","animation-iteration-count","animation-name",
      "animation-play-state","animation-timing-function","backface-visibility",
      "perspective","perspective-origin","transform",
      "transform-origin","transform-style","transition",
      "transition-property","transition-duration","transition-timing-function",
      "transition-delay","box-sizing","content",
      "cursor","nav-down","nav-index",
      "nav-left","nav-right","nav-up",
      "outline","outline-color","outline-offset",
      "outline-style","outline-width","resize",
      "text-overflow","column-count","column-fill",
      "column-gap","column-rule","column-rule-color",
      "column-rule-style","column-rule-width","column-span",
      "column-width","columns","page-break-after",
      "page-break-before","page-break-inside","quotes",
      "filter"
      };


(* ::Subsubsubsection::Closed:: *)
(*AllowedTypes*)



$CSSDefaultAllowedTypes=
  Alternatives@@
    {
      "a","abbr","acronym",
      "address","applet","area",
      "article","aside","audio",
      "b","base","basefont",
      "bdi","bdo","big",
      "blockquote","body",
      "br","button","buildto",
      "canvas","caption","center",
      "cite","code","col",
      "colgroup",
      "data","datalist",
      "dd","del","details",
      "dfn","dialog","dir",
      "div","dl","dt",
      "em","embed",
      "fieldset","figcaption","figure",
      "font","footer","form",
      "frame","frameset",
      "header","hr",
      "h1","h2","h3",
      "h4","h5","h6",
      "i","iframe","img",
      "inputcell",
      "input","ins",
      "kbd","keygen",
      "label","legend","li",
      "link",
      "main","map","mark",
      "menu","menuitem",
      "meta","meter",
      "nav","noframes",
      "noscript",
      "object","ol",
      "optgroup","option",
      "output",
      "p","param",
      "picture","pre",
      "progress",
      "q",
      "rp","rt","ruby",
      "s","samp","script",
      "section","select","small",
      "source","span","strike",
      "strong","style","sub",
      "summary","sup",
      "table","tbody","td",
      "textarea","tfoot","th",
      "thead","time","title",
      "tr","track","tt",
      "u","ul",
      "var","video",
      "wbr"
      };


(* ::Subsubsubsection::Closed:: *)
(*$CSSPropertyRules*)



$CSSDefaultPropertyRules=
  {
    FontColor->"color",
    FrameStyle->"border",
    FrameMargins->"margin",
    TextAlignment->"text-align",
    TabSpacings->"tab-size",
    SourceLink->"src",
    ButtonFunction->
      "onclick",
    Annotation->"alt",
    Hyperlink->"href",
    RoundingRadius->"border-radius",
    LineSpacing->"line-height",
    ImageSize->{"width","height"},
    CellSize->{"width", "height"},
    e_:>
      (
        ToLowerCase[
          StringJoin@{
            StringTake[#,1],
            StringReplace[StringDrop[#,1],
              l:LetterCharacter?(Not@*LowerCaseQ):>"-"<>l]
            }&@ToString[e]
          ]
        )
    };


(* ::Subsubsubsection::Closed:: *)
(*$CSSValueRules*)



$CSSDefaultValueRules=
  Join[
    Map[
      Replace[#,
        Hold[c_]:>
          (c->ToLowerCase@ToString[Unevaluated[c]])
        ]&,
      Thread@Hold@{
        Red,White,Blue,Black,Yellow,
        Green,Orange,Purple,Pink,Gray,
        LightBlue,LightRed,LightGray,LightYellow,
        LightGreen,LightOrange,LightPurple,LightPink,
        Thick,Dotted,Thin,Dashed
        }],{
    c_?ColorQ:>
      "#"<>Map[
        StringPadLeft[
          IntegerString[#,16],
          2,
          "0"
          ]&,
        Floor[255*Apply[List,ColorConvert[c,RGBColor]]]
        ],
    i_Integer:>
      ToString[i]<>"px",
    q_Quantity:>
      StringReplace[
        ToString[q],
        " "->""
        ],
    Scaled[i_]:>
      ToString@Floor[i*100]<>"%",
    r_Rule:>
      (cssGenerate[r]),
    {l__}|Directive[l__]:>
      StringRiffle@Map[#/.$CSSValueRules&,{l}],
    d_Dynamic:>
      (Setting[d]/.$CSSValueRules),
    i_:>ToLowerCase@ToString[i]
    }
  ];


(* ::Subsubsubsection::Closed:: *)
(*$CSSTypeRules*)



$CSSDefaultTypeRules=
  {
    "Title"->"h1",
    "Subtitle"->"h2",
    "Section"->"h3",
    "Subsection"->"h4",
    "Subsubsection"->"h5",
    "Subsubsubsection"->"h6",
    "Hyperlink"->"a",
    "HyperlinkActive"->"a:hover",
    "Graphics"->"img",
    "Text"->"p",
    s_String:>(ToLowerCase[s])
    };


(* ::Subsubsubsection::Closed:: *)
(*cssThreadedOptions*)



cssThreadedOptions[propBase_,propOps_,vals_]:=
  MapThread[
    If[!MatchQ[#2,Inherited|None],
      If[StringContainsQ[propBase,"-"],
        StringReplace[propBase,{
          "-"->("-"<>#<>"-")
          }]->(#2/.$CSSValueRules),
        StringJoin[propBase,"-"<>#]->(#2/.$CSSValueRules)
        ],
      Nothing
      ]&,{
    propOps,
    vals
    }]


(* ::Subsubsubsection::Closed:: *)
(*cssGenerate*)



cssGenerate//Clear;
cssGenerate[
  prop_->val:Except[{__Rule}]
  ]:=
  With[{
    propBase=
      prop/.$CSSPropertyRules
    },
    If[!MatchQ[propBase, $CSSAllowedProperties],
      Nothing,
      If[Not@ListQ@propBase,
        Sequence@@
            Replace[val,
              {
                {{l_,r_},{b_,h_}}:>
                  If[StringContainsQ[propBase,"radius"],
                    cssThreadedOptions[
                      propBase,
                      {"left-bottom","right-bottom","left-top","right-top"},
                      {l,r,b,h}
                      ],
                    cssThreadedOptions[
                      propBase,
                      {"left","right","bottom","top"},
                      {l,r,b,h}
                      ]
                    ],
                {l_,r_}:>
                  cssThreadedOptions[
                    propBase,
                    {"left","right"},
                    {l,r}
                    ],
                v_:>
                  {propBase->(v/.$CSSValueRules)}
                }
              ],
        If[ListQ@val,
          Sequence@@cssGenerate[Thread[propBase->val]],
          cssGenerate[First@propBase->val]
          ]
        ]
      ]
    ];
cssGenerate[
  type:_String|_Symbol->spec:{__Rule}
  ]:=
  With[{tp=ToString[type]/.$CSSTypeRules},
    If[!MatchQ[tp, $CSSAllowedProperties],
      Nothing,
      tp->Map[cssGenerate, spec]
      ]
    ];
cssGenerate[r:{__Rule}]:=
  cssGenerate/@r;
cssGenerate[a_Association]:=
  KeyValueMap[cssGenerate,a];
cssGenerate[{},Optional[_,_]]:={};


(* ::Subsubsubsection::Closed:: *)
(*generateCSSString*)



generateCSSString[{}, _]:=""


generateCSSString[r:{__Rule}, riffle:_String:" "]:=
  StringRiffle[
    KeyValueMap[#<>": "<>#2<>";"&, Association[r]],
    riffle
    ];
generateCSSString[r:{__Rule}, {riffle_String, _}]:=
  generateCSSString[r, riffle]


generateCSSString[a_Association?AssociationQ, 
  riffle:{_String, _String}:{" ", "\n"}]:=
  StringRiffle[
    KeyValueMap[
        (#/.$CSSTypeRules)<>"{"<>riffle[[1]]<>
          generateCSSString[#2, riffle[[1]]]<>riffle[[1]]<>"}"&,
      a
      ],
    riffle[[2]]
    ];


(* ::Subsubsubsection::Closed:: *)
(*generateObjectStyles*)



generateObjectStyles//Clear


generateObjectStyles[nb_NotebookObject]:=
  Prepend[
    AssociationMap[
      AbsoluteCurrentValue[nb, {StyleDefinitions, #}]&,
      Select[StringQ]@Keys@
        FE`Evaluate@
          FEPrivate`GetPopupList[nb,"MenuListStyles"]
      ],
    "body"->Options[nb]
    ]


generateObjectStyles[cell_CellObject]:=
  Normal@Merge[
    {
      Options[cell],
      AbsoluteCurrentValue[ParentNotebook[cell],
        {StyleDefinitions, NotebookRead[cell][[2]]}
        ]
      },
    First
    ]


generateObjectStyles[box_BoxObject]:=
  Options[box];


(* ::Subsubsubsection::Closed:: *)
(*CSSGenerate*)



Options[CSSGenerate]=
  {
    "PropertyMapping"->Automatic,
    "AllowedProperties"->Automatic,
    "ValueMapping"->Automatic,
    "TypeMapping"->Automatic,
    "AllowedTypes"->Automatic,
    "GenerateString"->True,
    "RiffleCharacter"->{" ", "\n"}
    };
CSSGenerate[l:(_List?OptionQ|_Association?(OptionQ@*Normal)), ops:OptionsPattern[]]:=
  Block[
    {
      $CSSPropertyRules=
        Replace[OptionValue["PropertyMapping"],
          Except[_?OptionQ]:>$CSSDefaultPropertyRules
          ],
      $CSSValueRules=
        Replace[OptionValue["ValueMapping"],
          Except[_?OptionQ]:>$CSSDefaultValueRules
          ],
      $CSSTypeRules=
        Replace[OptionValue["TypeMapping"],
          Except[_?OptionQ]:>$CSSDefaultTypeRules
          ],
      $CSSAllowedProperties=
        Replace[OptionValue["AllowedProperties"],
          {
            {s__String}:>
              Alternatives[s],
            Except[_Alternatives]:>
              $CSSDefaultAllowedProperties
            }
          ],
      $CSSAllowedTypes=
        Replace[OptionValue["AllowedTypes"],
          {
            {s__String}:>
              Alternatives[s],
            Except[_Alternatives]:>
              $CSSDefaultAllowedTypes
            }
          ]
      },
    If[TrueQ@OptionValue["GenerateString"], 
      generateCSSString[#, 
        Replace[OptionValue["RiffleCharacter"], 
          {
            s_String?StringQ:>
              {s, "\n"},
            Except[{_String?StringQ, _String?StringQ}]:>
              {" ", "\n"}
            }]
        ]&,
      Identity
     ]@
      If[AllTrue[Values@l, OptionQ],
        Map[cssGenerate, 
          If[$CSSAllowedTypes===All,
            Association[l],
            KeySortBy[FirstPosition[$CSSTypeRules, #/.$CSSTypeRules]&]@
              KeySelect[Association[l], 
                MatchQ[#/.$CSSTypeRules, $CSSAllowedTypes]&
                ]
            ]
          ],
        cssGenerate[l]
        ]
    ]


CSSGenerate[
  nb:
    _NotebookObject|_CellObject|_BoxObject|
    _FrontEnd`EvaluationNotebook|_FrontEnd`InputNotebook:FrontEnd`InputNotebook[], 
  ops:OptionsPattern[]
  ]:=
  CSSGenerate[generateObjectStyles[FE`Evaluate@nb], ops]


End[];



