(* ::Package:: *)

(* Autogenerated Package *)

MarkdownNotebookDirectory::usage="";
MarkdownNotebookFileName::usage="";


MarkdownNotebookMetadata::usage="";


MarkdownSiteBase::usage="";
MarkdownContentExtension::usage="";
MarkdownOutputPath::usage="";


MarkdownNotebookContentPath::usage=""
MarkdownNotebookContext::usage=""
$MarkdownSiteRoot::usage="";

$MarkdownNewMDFileTemplate::usage="";


MarkdownContentPath::usage="";


MarkdownNameToSlug::usage="";
MarkdownFileMetadataTitle::usage="";
MarkdownFileMetadataSlug::usage="";
MarkdownFileMetadata::usage="";
MarkdownMetadataFormat::usage="";


Begin["`Private`"];


(* ::Subsection:: *)
(*NotebookToMarkdown*)



$MarkdownSiteRoot=
  FileNameJoin@{
    $WebTemplatingRoot,
    "markdown"
    };


(* ::Subsubsection::Closed:: *)
(*Site*)



$MarkdownStandardContentExtensions=
  {
    "content",
    "project",
    "proj"
    };


MarkdownSiteBase[f_String]:=
  Replace[Reverse@FileNameSplit[f],
    {
      {d:Shortest[___],
        (Alternatives@@$MarkdownStandardContentExtensions)|"output", n___}:>
        FileNameJoin@Reverse@{n},
      _:>If[DirectoryQ@f, f, DirectoryName[f]]
      }
    ]


MarkdownContentExtension[root_]:=
  SelectFirst[
    $MarkdownStandardContentExtensions,
    DirectoryQ@FileNameJoin@{root,#}&,
    Nothing
    ];


MarkdownContentPath[f_String]:=
  Replace[Reverse[FileNameSplit@f], 
    {
      {Shortest[p___], Alternatives@$MarkdownStandardContentExtensions, ___}:>
        FileNameJoin@Reverse@{p},
      _:>f
      }
    ];


MarkdownOutputPath[f_String]:=
  Replace[Reverse@FileNameSplit[f],
    {
      {Shortest[p___], "output", ___}:>FileNameJoin@Reverse@{p},
      _:>f
      }
    ]


(* ::Subsubsection::Closed:: *)
(*File Templates*)



(* ::Subsubsubsection::Closed:: *)
(*Template*)



$MarkdownNewMDFileTemplate=
"`headers`

`body`
";


(* ::Subsubsubsection::Closed:: *)
(*Metadata*)



(* ::Subsubsubsubsection::Closed:: *)
(*NameToSlug*)



MarkdownNameToSlug[t_]:=
  ToLowerCase@
    StringReplace[
      t,
      {
        Whitespace->"-",
        Except[WordCharacter]->""
        }
      ]


(* ::Subsubsubsubsection::Closed:: *)
(*Title*)



MarkdownFileMetadataTitle[t_,name_,opsassoc_]:=
  Replace[t,
    {
      Automatic:>name
      }];


(* ::Subsubsubsubsection::Closed:: *)
(*Slug*)



MarkdownFileMetadataSlug[t_,name_,opsassoc_]:=
  Replace[t,
    {
      Automatic:>
        MarkdownNameToSlug@
          MarkdownFileMetadataTitle[
            Lookup[opsassoc,"Title",t],
            name,
            opsassoc
            ]
      }
    ]


(* ::Subsubsubsubsection::Closed:: *)
(*Metadata*)



MarkdownFileMetadata[val_,opsassoc_]:=
  Replace[val,{
    _List:>
      StringRiffle[ToString/@val,","],
    _DateObject:>
      StringReplace[DateString[val,"ISODateTime"],"T"->" "]
    }]


(* ::Subsubsubsubsection::Closed:: *)
(*MetadataFormat*)



MarkdownMetadataFormat[name_,ops_]:=
  With[{opsassoc=Association@ops},
    Block[{Internal`$ContextMarks=False},
      Function[StringRiffle[ToString/@#,"\n"]]@
        KeyValueMap[
          ToString[#]<>": "<>
            ToString@
              StringReplace[
                ToString@
                  Switch[#,
                    "Title",
                      MarkdownFileMetadataTitle[#2,name,opsassoc],
                    "Slug",
                      MarkdownFileMetadataSlug[#2,name,opsassoc],
                    _,
                      MarkdownFileMetadata[#2,opsassoc]
                    ],
                "\n"->"\ "
                ]&,
          KeySortBy[
            Switch[#,"Title",0,_,1]&
            ]@opsassoc
          ]
      ]
    ];


(* ::Subsubsection::Closed:: *)
(*NotebookMetadata*)



MarkdownNotebookMetadata[c:{Cell[_BoxData,"Metadata",___]...}]:=
  Join@@Select[Normal@ToExpression[First@First@#]&/@c,OptionQ];
MarkdownNotebookMetadata[nb_Notebook]:=
  MarkdownNotebookMetadata@
    Cases[
      NotebookTools`FlattenCellGroups[First@nb],
      Cell[_BoxData,"Metadata",___]
      ];
MarkdownNotebookMetadata[nb_NotebookObject]:=
  MarkdownNotebookMetadata@
    Cases[
      NotebookRead@Cells[nb,CellStyle->"Metadata"],
      Cell[_BoxData,___]
      ]


(* ::Subsubsection::Closed:: *)
(*MarkdownNotebook**)



MarkdownNotebookDirectory[nb_]:=
  Replace[Quiet@NotebookDirectory[nb],
    Except[_String?DirectoryQ]:>
      With[{
        d=
          FileNameJoin@{
            $TemporaryDirectory,
            "markdown_export"
            }
        },
        If[!DirectoryQ[d],
          CreateDirectory[d]
          ];
        d
        ]
    ];


MarkdownNotebookFileName[nb_]:=
  Replace[Quiet@NotebookFileName[nb],
    Except[_String?FileExistsQ]:>
      FileNameJoin@{
        $TemporaryDirectory,
        "markdown_export",
        "markdown_notebook.nb"
        }
    ];


MarkdownNotebookContentPath[nb_]:=
  MarkdownContentPath@
    MarkdownNotebookFileName[nb];


NotebookToMarkdown::nocont=
  "Can't handle notebook with implicit CellContext ``. Use a string instead.";
MarkdownNotebookContext[nb_]:=
  Replace[CurrentValue[nb, CellContext],
    c:Except[_String?(StringEndsQ["`"])]:>
      (
        (*PackageRaiseException[
					Automatic,
					Evaluate[NotebookToMarkdown::nocont],
					c
					];*)
        (* hmm... *)
        "Global`"
        )
    ]


End[];


