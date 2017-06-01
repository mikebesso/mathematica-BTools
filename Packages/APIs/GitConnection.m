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



(* ::Section:: *)
(*Git Connections*)



(* ::Subsection:: *)
(*Git*)



GitRun::usage="ProcessRun wrapper for git";


GitCreate::usage="Creates a new repository";
GitInit::usage="Initializes a git repository";
GitClone::usage="Clones a repository";


GitIgnore::usage="Adds to the .gitignore file for a directory";
GitAdd::usage="Adds a file to the staging area of a  git repository";
GitCommit::usage="Runs the commit command, using -a by default";


GitStatus::usage="Gets the status of a repository";
GitLog::usage="Gets the log of the git repo";
GitConfig::usage="Sugar on the GitConfig tool";
GitHelp::usage="Gets help from the git man pages";


GitRemote::usage=
	"git remote command";
GitAddRemote::usage=
	"git remote add origin command";
GitRemoveRemote::usage=
	"Removes remote";
GitFetch::usage="git fetch";
GitPush::usage="git push";
GitPushOrigin::usage="git push origin master";
GitBranch::usage="git branch";


GitRepositories::usage="Finds all the directories that support a git repo";
$GitRepo::usage="The current git repo";
GitRepo::usage=
	"Returns: 
the arg if it is a repo, 
a github URL if the arg is github:<repo>, 
else None";
GitRepoQ::usage=
	"Returns true if the thing is a directory with a .git file";


(*Git::usage=
	"A general head for all Git actions";*)


(* ::Subsection:: *)
(*SVN*)



SVNRun::usage="Runs SVN";
SVNFileNames::usage="svn ls";


SVNCheckOut::usage="Uses SVN to clone from a server";
SVNExport::usage="Uses SVN to pull a single file from a server";


(* ::Subsection:: *)
(*GitHub*)



$GitHubUserName::usage=
	"The user's github username";
$GitHubPassword::usage=
	"The user's github password";
GitHubPath::usage=
	"Represents a github path";
GitHubRepoQ::usage=
	"Returns if the path could be a github repo";


GitHubSVN::usage="Formats a repo for SVN";


$GitHubCalls::usage=
	"A collection of known calls for the GitHub function";
GitHub::usage=
	"A connection to the GitHub functinality";
GitHubImport::usage=
	"Imports and converts GitHub JSON";


Begin["`Private`"];


(* ::Subsection:: *)
(*Constants*)



If[Not@MatchQ[$GitRepo,_String?DirectoryQ],
	$GitRepo=None
	];


If[Not@ValueQ@$GitHubUserName,
	$GitHubUserName:=
		Replace[
			$KeyChain["$GitHubUserName"],
			_Missing:>
				Do[
					With[{f=
						FileNameJoin@{
							$PackageDirectory,
							"Private",
							d}
						},
						If[FileExistsQ@f,
							$GitHubUserName=Import@f;
							Break[]
							]
						],
					{d,
						{
							"GitHubUsername.m",
							"GitHubUsername.wl"
							}
						}
					]
			]
	];


GitHubPassword[s_String]:=
	KeyChainGet[{
		"github.com",
		s
		},
		True];
GitHubPassword[Optional[Automatic,Automatic]]:=
	GitHubPassword[$GitHubUserName];
Clear@$GitHubPassword;
$GitHubPassword:=
	GitHubPassword[Automatic];


(*If[ValueQ@$GitHubUserName&&!KeyMemberQ[$gitHubPassCache,$GitHubUserName],
	$gitHubPassCache[$GitHubUserName]:=
		Do[
			With[{f=
				FileNameJoin@{
					$PackageDirectory,
					"Private",
					d}
				},
				If[FileExistsQ@f,
					Replace[Import@f,
						s_String:>
							($gitHubPassCache[$GitHubUserName]=s);
						];
					Return[True]
					]
				],
			{d,
				{
					"GitHubPassword.m",
					"GitHubPassword.wl"
					}
				}
			]
	];*)


$GitHubSSHConnected:=
	($GitHubSSHConnected=
		Quiet[ProcessRun[{"ssh","-T","git@github.com"}];
			Length@$MessageList===0
			]
		);


(* ::Subsection:: *)
(*Git*)



doInDir[dir_String?DirectoryQ,cmd_]:=
	With[{d=ExpandFileName@dir},
			SetDirectory@d;
			With[{r=cmd},
				ResetDirectory[];
				r
				]
			];
doInDir~SetAttributes~HoldRest;


ProcessRun;
GitRun::err=ProcessRun::err;


GitRun[dir:_String?DirectoryQ|None|Automatic:None,cmds__String]:=
	With[{d=Replace[dir,Automatic:>$GitRepo]},
		Replace[
			GitRun::err,
			_MessageName:>
				(GitRun::err=ProcessRun::err)
			];
		If[MatchQ[d,_String],
			ProcessRun[{"git",cmds},GitRun::err,ProcessDirectory->d],
			ProcessRun[{"git",cmds},GitRun::err]
			]
		];
GitRun::nodir="`` is not a valid directory";
GitRun::nrepo="`` not a git repository";


GitRepoQ[d:(_String|_File)?DirectoryQ]:=
	DirectoryQ@FileNameJoin@{d,".git"};
GitRepoQ[_]:=False


GitCreate[dir_String]:=
	With[{d=ExpandFileName@dir},
		Quiet@CreateDirectory@d;
		GitInit[d]
		];


GitInit[dir:_String?DirectoryQ|Automatic:Automatic]:=
	GitRun[dir,"init"];


GitClone[
	repo:_String|_File|_URL,
	dir:_String|_File|Automatic:Automatic]:=
	With[{
		r=
			Replace[repo,{
				File[d_]:>
					If[GitRepoQ@d,
						d,
						GitRepo
						],
				URL[d_]:>
					d
				}],
		d=
			Replace[dir,
				Automatic:>
					FileNameJoin@{
						$TemporaryDirectory,
						Switch[repo,
							_String|_File,
								FileBaseName@repo,
							_URL,
								URLParse[repo,"Path"][[-1]]
							]
						}
				]
			},
		Quiet@
			DeleteDirectory[d,DeleteContents->True];
		CreateDirectory@d;
		GitRun["clone",r,d];
		d
		];


GitIgnore[dir:_String?DirectoryQ|Automatic:Automatic,filePatterns:{___}]:=
	With[{d=Replace[dir,Automatic:>$GitRepo]},
		If[MatchQ[d,_String?DirectoryQ],
			With[{file=OpenAppend@FileNameJoin@{d,".gitignore"}},
				Do[
					WriteLine[file,f],
					{f,filePatterns}
					];
				Close@file;
				GitRun[d,"add",".gitignore"]
				],
			Message[GitRun::nodir,d];$Failed
			]
		];


GitAdd[dir:_String?DirectoryQ|Automatic:Automatic,files___]:=
	GitRun[dir,"add",files];


Options[GitCommit]={Message->"Commited via Mathematica"};
GitCommit[dir:_String?DirectoryQ|Automatic:Automatic,
	opts___String,
	OptionsPattern[]]:=
	With[{squargs=
		If[
			Not@MemberQ[{opts},"-m"],
			Join[{opts},{"-m",OptionValue@Message}],
			{opts}]},
		GitRun[dir,"commit",Sequence@@squargs]
		];


GitLog[dir:_String?DirectoryQ|Automatic:Automatic,
		pFlag_:"-p",entries_:"-2",opts___]:=
	GitRun[dir,"log",opts];


GitStatus[dir:_String?DirectoryQ|Automatic:Automatic]:=
	GitRun[dir,"status"];


GitConfig[setting:_String:"--global",opts___String]:=
	GitRun["config",setting,opts];
GitConfig[setting:_String:"--global","Username"->name_]:=
	GitConfig[setting,"user.name",name];
GitConfig[setting:_String:"--global","UserEmail"->email_]:=
	GitConfig[setting,"user.email",email];
GitConfig[setting:_String:"--global","TextEditor"->editor_]:=
	GitConfig[setting,"core.editor",editor]
GitConfig[setting:_String:"--global",opts__Rule]:=
	StringJoin@
		Riffle[
			Cases[
				Table[
					GitConfig[setting,opt],
					{opt,{opts}}
					],
				_String
				],
			"\n"
			];


GitHelp[thing_String]:=
	GitRun["help",thing];


GitRepositories[dirs:{(_String?DirectoryQ)..}|_String?DirectoryQ,depth:_Integer|\[Infinity]:2]:=
	ParentDirectory/@FileNames[".git",dirs,depth];


(*Options declared later*)
GitRepo[repo_String?(StringMatchQ["github:*"]),ops:OptionsPattern[]]:=
	GitHubRepo[StringTrim[repo,"github:"],{"Username"->"",ops}];
GitRepo[repo:(_String|_File)?DirectoryQ]:=
	Replace[
		GitRepositories[repo,1],{
		{d_,___}:>d,
		_:>None
		}];
GitRepo[r:_String|_URL]:=
	With[{u=URLParse@r},
		If[u["Scheme"]===None,
			If[u["Domain"]===None,
				If[Length@u["Path"]<2||!StringMatchQ[u["Path"]//First,"*.*"],
					None,
					URLBuild@Append[u,"Scheme"->"https"]
					],
				URLBuild@Append[u,"Scheme"->"https"]
				],
			URLBuild@u
			]
		];
GitRepo[r_]:=None;
GitRepoQ[r:(_String|_File)?DirectoryQ]:=
	(GitRepo@r=!=None);


GitAddRemote[
	dir:_String?DirectoryQ|Automatic:Automatic,
	remote:_String|_URL]:=
	GitRun[dir,
		"remote","add","origin",
		URLBuild@remote
		];


GitRemoveRemote[
	dir:_String?DirectoryQ|Automatic:Automatic,
	remote:_String|_URL]:=
	GitRun[dir,
		"remote","rm","origin"
		];


Options[GitPush]={
	"Username"->
		None,
	"Password"->
		None
	};
GitPush[
	dir:_String?DirectoryQ,
	loc_String,
	branch:_String:"master",
	ops:OptionsPattern[]]:=
	GitRun[dir,
		"push",
		loc,
		branch];


GitPushOrigin[dir:_String?DirectoryQ|Automatic:Automatic]:=
	GitPush[dir,"origin","master"];


$GitActions=<|
	"init"->
		GitInit,
	"clone"->
		GitClone,
	"addremote",
		GitAddRemote,
	"removeremote",
		GitRemoveRemote,
	"push"->
		GitPush,
	"pushorigin"->
		GitPushOrigin
	|>;


(* ::Subsection:: *)
(*SVN*)



Options[SVNRun]=
	Normal@Merge[{
		Options@ProcessRun,
		"TrustServer"->False
		},
		First
		];
SVNRun[cmd_,
	kwargs:(_Rule|_RuleDelayed|_String)...,
	repo_String,
	others:(_Rule|_RuleDelayed|_String)...,
	ops:OptionsPattern[]]:=
	ProcessRun[{
		"svn",cmd,
		kwargs,
		If[OptionValue@"TrustServer","--trust-server-cert",Nothing],
		If[FileExistsQ@repo,ExpandFileName@repo,repo],
		others
		},
		ops];


Options[SVNFileNames]=
	Options@SVNRun;
SVNFileNames[repo_,ops:OptionsPattern[]]:=
	Replace[SVNRun["ls",repo,ops],
		fn_String:>
			With[{lines=StringSplit[fn,"\n"]},
				If[FileExistsQ@repo,
					FileNameJoin@{repo,#}&/@lines,
					URLBuild@{repo,#}&/@lines
					] 
				]
		];


Options[SVNCheckOut]=
	Options@SVNRun;
SVNCheckOut[repo_,dir:_String|Automatic:Automatic,ops:OptionsPattern[]]:=
	With[{pulldir=
		Replace[dir,{
			s_String?(Not@*FileExistsQ):>
				(If[FileExtension@s=="",
					CreateDirectory@s
					];
					s),
			Automatic:>
				With[{d=FileNameJoin@{$TemporaryDirectory,FileNameTake@repo}},
					If[FileExtension@d=="",
						Quiet@DeleteDirectory[d,DeleteContents->True];
						CreateDirectory@d
						];
					d
					]
			}]},
	SVNRun["checkout",
		repo,
		ExpandFileName@pulldir,
		ops
		];
	pulldir
	]


Options[SVNExport]=
	Normal@Merge[{
		Options@SVNRun,
		OverwriteTarget->False
		},
		Last];
SVNExport[repo_,file:_String|Automatic:Automatic,ops:OptionsPattern[]]:=
	With[{f=
		Replace[file,{
				Automatic:>
					FileNameJoin@{$TemporaryDirectory,FileNameTake@repo}
				}]},
		If[OptionValue@OverwriteTarget,Quiet@DeleteFile@f];
		SVNRun["export",
			repo,
			ExpandFileName@f,
			FilterRules[{ops},Options@SVNRun]
			];
		f
		]


(* ::Subsection:: *)
(*GitHub*)



(* ::Subsubsection::Closed:: *)
(*GitHubPath*)



$GitHubEncodePassword=False;


Options[GitHubPath]={
	"Username"->Automatic,
	"Password"->None
	};
Options[formatGitHubPath]=
	Options[GitHubPath];
formatGitHubPath[path__String,ops:OptionsPattern[]]:=
	URLBuild@<|
		"Scheme"->
			"https",
		"Domain"->
			"github.com",
		If[$GitHubEncodePassword||
			MatchQ[OptionValue@"Password",_String|Automatic],
			"Username"->
				Replace[OptionValue["Username"],{
					Automatic:>
						Replace[OptionValue@"Password",
							Automatic|_String:>$GitHubUserName
							],
					Except[_String]->None
					}],
			Nothing
			],
		If[$GitHubEncodePassword||
			MatchQ[OptionValue@"Password",_String|Automatic],
			"Password"->
				Replace[
					Replace[OptionValue["Username"],{
						Automatic:>$GitHubUserName,
						Except[_String]->None
						}],
					s_String:>
						Replace[OptionValue["Password"],
							Automatic:>GitHubPassword[s]
							]
					],
			Nothing
			],
		"Path"->{
			Replace[OptionValue@"Username",
				Automatic:>$GitHubUserName
				],
			path
			}
		|>;
GitHubPath[path__String,ops:OptionsPattern[]]/;(TrueQ@$GitHubPathFormat):=
	formatGitHubPath[path,ops];


GitHubPath/:
	Normal[GitHubPath[repos___,ops__?OptionQ]]:=
		{
			FirstCase[{ops},
				("Username"->u_):>u,
				$GitHubUserName
				],
			repos
			};
GitHubPath/:
	URL[GitHubPath[path__String,ops:OptionsPattern[]]]:=
		formatGitHubPath[path,ops]


(* ::Subsubsection::Closed:: *)
(*GitHubSVN*)



Options[GitHubSVN]=
	Options[GitHubPath];
Options[formatGitHubSVN]=Options[GitHubSVN];
formatGitHubSVN[
	root_String?(Not@*GitHubRepoQ),
	subparts___String,
	ops:OptionsPattern[]
	]:=
	URLBuild@{
		formatGitHubPath[root,ops],
		"trunk",
		subparts
		};
GitHubSVN[path__String,ops:OptionsPattern[]]/;(TrueQ@$GitHubRepoFormat):=
	formatGitHubSVN[path,ops]


(* ::Subsubsection::Closed:: *)
(*GitHubPathParse*)



GitHubPathParse[path:_String|_URL]:=
	If[GitHubPathQ[path],
		Replace[
			DeleteCases[""]@
				URLParse[path,"Path"],{
			{user_,parts__}|
			{user_,parts__}:>
				GitHubPath[parts,"Username"->user]
			}],
		$Failed
		];


(* ::Subsubsection::Closed:: *)
(*GitHubRepoParse*)



GitHubRepoParse[path:_String|_URL]:=
	If[GitHubPathQ[path],
		Replace[
			DeleteCases[""]@
				URLParse[path,"Path"],{
			{"repos",user_,parts__}|
			{user_,parts__,"releases"|"deployments"}|
			{user_,parts__,"releases"|"deployments","tag",___}:>
				GitHubPath[parts,"Username"->user]
			}],
		$Failed
		];


(* ::Subsubsection::Closed:: *)
(*GitHubPathQ*)



GitHubPathQ[path:_String|_URL]:=
	With[{p=URLParse[path]},
		MatchQ[p["Scheme"],"http"|"https"]&&
		p["Domain"]=="github.com"&&
		Length@p["Path"]>0
		];
GitHubPathQ[_GitHubPath]:=
	True;


(* ::Subsubsection::Closed:: *)
(*GitHubRepoQ*)



GitHubRepoQ[path:_String|_URL]:=
	With[{p=URLParse[path]},
		MatchQ[p["Scheme"],"http"|"https"]&&
		p["Domain"]=="github.com"&&
		Length@p["Path"]>0&&
		!MatchQ[p["Path"],
			{"repos",__}|
			{__,"releases"|"deployments"}|
			{__,"releases"|"deployments","tag",___}
			]
		];
GitHubRepoQ[GitHubPath[path__String,___?OptionQ]]:=
	!MatchQ[{path},
		{"repos",__}|
		{__,"releases"|"deployments"}|
		{__,"releases"|"deployments","tag",___}
		];
GitHubRepoQ[_]:=False


(* ::Subsubsection::Closed:: *)
(*GitHubReleaseQ*)



GitHubReleaseQ[GitHubPath[p__String,___?OptionQ]]:=
	MatchQ[{p},
		{__,"releases"}|
		{__,"releases","tag",_}
		];
GitHubReleaseQ[path:_String|_URL]:=
	If[GitHubPathQ@path,
		Replace[GitHubPathParse[path],{
			g_GitHubPath:>
				GitHubReleaseQ@g,
			_->False
			}],
		False
		];


(* ::Subsubsection::Closed:: *)
(*GitHubQuery*)



GitHubQuery[
	path:_?(MatchQ[Flatten@{#},{___String}]&):{},
	query:(_String->_)|{(_String->_)...}:{},
	headers:_Association:<||>]:=
	HTTPRequest[
		URLBuild@<|
			"Scheme"->"https",
			"Domain"->"api.github.com",
			"Path"->Flatten@{path},
			"Query"->{query}
			|>,
		headers
		];


(* ::Subsubsection::Closed:: *)
(*Auth*)



(*GitHubAuth[
	user:_String|Automatic:Automatic,
	scopes:_String|{__String}:{"public_repo"}]:=
	GitHubQuery[
		Replace[user,Automatic:>$GitHubUserName],
		<|
			"Headers"\[Rule]{
				"Authorization"\[Rule]"token OAUTH-TOKEN",
				"
				}
			|>
		];*)


(* ::Subsubsection::Closed:: *)
(*AuthHeader*)



GitHubAuthHeader[
	user:_String|Automatic:Automatic,
	password:_String|Automatic:Automatic
	]:=
	StringJoin@{
		"Basic ",
		Developer`EncodeBase64@
			StringJoin@{
				Replace[user,
					Automatic:>
						$GitHubUserName
					],
				":",
				Replace[password,
					Automatic:>
						GitHubPassword[user]
					]
				}
		};


(* ::Subsubsection::Closed:: *)
(*UserAPI*)



GitHubUserAPI[
	type:"users"|"org":"users",
	user:_String|Automatic:Automatic,
	path:{___String}|_String:{},
	query:(_String->_)|{(_String->_)...}:{},
	headers:_Association:<||>
	]:=
	GitHubQuery[{
		type,
		Replace[user,Automatic:>$GitHubUserName],
		Flatten@path
		},
		query,
		headers
		];


(* ::Subsubsection::Closed:: *)
(*ReposAPI*)



GitHubReposAPI[
	repo_GitHubPath?GitHubRepoQ,
	path:{___String}|_String:{},
	query:(_String->_)|{(_String->_)...}:{},
	headers:_Association:<||>
	]:=
	GitHubQuery[
		Flatten@{
			"repos",
			Sequence@@Normal@repo,
			path
			},
		query,
		headers
		];
GitHubReposAPI[
	s_String?GitHubRepoQ,
	path:{___String}|_String:{},
	query:(_String->_)|{(_String->_)...}:{},
	headers:_Association:<||>
	]:=
	GitHubReposAPI[
		GitHubPathParse[s],
		path,
		query,
		headers
		];


(* ::Subsubsection::Closed:: *)
(*Repositories*)



GitHubRepositories[
	type:"user"|"org":"user",
	user:_String|Automatic:Automatic,
	query:(_String->_)|{(_String->_)...}:{},
	headers:_Association:<||>
	]:=
	GitHubUserAPI[type,user,"repos",query,headers];


(* ::Subsubsection::Closed:: *)
(*Create*)



Options[GitHubCreate]=
	{
		"Username"->Automatic,
		"Password"->Automatic,
		"Description"->None,
		"HomePage"->None
		};
GitHubCreate[
	repo_String,
	ops:OptionsPattern[]
	]:=
	With[{u=Replace[OptionValue["Username"],Automatic:>$GitHubUserName]},
		GitHubQuery[
			{
				"user",
				"repos"
				},
			<|
				"Method"->"POST",
				"Body"->
					ExportString[
						Map[ToLowerCase[First@#]->Last@#&,
							DeleteCases[_->None]@
								FilterRules[
									{
										"Name"->repo,
										ops
										},
									Except["Password"]
									]
							],
						"JSON"
						],
				"Headers"->{
					"Authorization"->
						GitHubAuthHeader[
							u,
							OptionValue["Password"]
							]
						}
				|>
			]
		];


(* ::Subsubsection::Closed:: *)
(*Delete*)



Options[GitHubDelete]=
	{
		"Username"->Automatic,
		"Password"->Automatic
		};
GitHubDelete[
	repo_GitHubPath?GitHubRepoQ,
	ops:OptionsPattern[]
	]:=
	With[{r=Normal@repo},
		GitHubReposAPI[
			repo,
			<|
				"Method"->"DELETE",
				"Headers"->{
					"Authorization"->
						GitHubAuthHeader[
							First@r,
							OptionValue["Password"]
							]
						}
				|>
			]
		];
GitHubDelete[
	s_String?GitHubRepoQ,
	ops:OptionsPattern[]
	]:=
	Block[{$GitHubPathFormat=False},
		GitHubDelete[GitHubRepoParse@s,ops]
		];
GitHubDelete[
	s_String?(
		URLParse[#,"Scheme"]===None&&
		Length@URLParse[#,"Path"]===1&),
	ops:OptionsPattern[]
	]:=
	GitHubDelete[
		GitHubPath[s,
			FilterRules[{ops},Options@GitHubPath]
			],
		ops]


(* ::Subsubsection::Closed:: *)
(*CreateReadme*)



GitHubCreateReadme[repo_?GitRepoQ,readmeText:_String:""]:=
	With[{o=
		OpenWrite@
			FileNameJoin@{
				repo,
				"README.md"
				}
		},
		WriteString[o,readmeText];
		Close@o
		];


(* ::Subsubsection::Closed:: *)
(*Releases*)



GitHubReleases[
	repo:(_GitHubPath|_String)?GitHubRepoQ,
	identifier:_String|_Integer|None:None]:=
	GitHubReposAPI[
		repo,
		Switch[identifier,
			None,
				"releases",
			_Integer|_?(StringMatchQ[ToLowerCase@#,"latest"]&),
				{"releases",ToLowerCase@ToString@identifier},
			_,
				{"releases","tags",ToLowerCase@ToString@identifier}
			]
		];
GitHubReleases[
	repo:(_GitHubPath|_String)?GitHubReleaseQ,
	identifier:_String|_Integer|None:None
	]:=
	Replace[Replace[repo,s_String:>GitHubPathParse[s]],{
		GitHubPath[s__,"releases","tag",tag_String,o__?OptionQ]:>
			GitHubReleases[GitHubPath[s,o],tag],
		GitHubPath[s__,"releases",o__?OptionQ]:>
			GitHubReleases[GitHubPath[s,o],identifier]
		}]


(* ::Subsubsection::Closed:: *)
(*Deployments*)



GitHubDeployments[repo:(_GitHubRepo|_String)?GitHubRepoQ,
	identifier:_String|_Integer|None
	]:=
	GitHubReposAPI[repo,
		If[identifier===None,
			"deployments",
			{"deployments",ToLowerCase@ToString@identifier}
			]
		];


(* ::Subsubsection::Closed:: *)
(*Pull *)



GitHubPull[
	repo:(_String|_GitHubPath)?GitHubRepoQ,
	dir:_String|Automatic:Automatic
	]:=
	Quiet[
		Replace[
			GitClone[
				If[MatchQ[repo,_GitHubPath],
					URL@repo,
					repo
					],
				dir],
			d:Except[_String?GitRepoQ]:>(
				Print@d;
				SVNCheckOut[repo,
					If[MatchQ[repo,_GitHubPath],
						URL@repo,
						repo
						],
				"TrustServer"->True]
				)
			],
	GitRun::err
	];
GitHubPull[
	repo:(_String|_GitHubPath)?GitHubReleaseQ,
	dir:_String|Automatic:Automatic
	]:=
	With[{release=
		GitHubImport["Releases",
			repo,
			"latest"
			]["Content"]
		},
		If[AssociationQ@release,
			If[Length@release["Assets"]>0,
				With[{url=
					release[["Assets",-1,"BrowserDownloadURL"]]
					},
					URLDownload[url,
						FileNameJoin@{
							Replace[dir,Automatic:>$TemporaryDirectory],
							URLParse[url,"Path"][[-1]]
							}
						]
					],
				ExtractArchive[
					URLDownload[
						release["ZipballURL"],
						FileNameJoin@{
							$TemporaryDirectory,
							URLParse[release["ZipballURL"],"Path"][[-1]]
							}
						],
					Replace[dir,
						Automatic:>
							$TemporaryDirectory
						]
					]
				],
			$Failed
			]
		]


(* ::Subsubsection::Closed:: *)
(*GitHub*)



$GitHubCalls=<|
	"repositories"->
		GitHubRepositories,
	"pull"->
		GitHubPull,
	"create"->
		GitHubCreate,
	"delete"->
		GitHubDelete,
	"createreadme"->
		GitHubCreateReadme,
	"releases"->
		GitHubReleases,
	"deployments"->
		GitHubDownloads
	|>;


PackageAddAutocompletions[
	"GitHub",
	{
		{	
			"Repositories","Pull",
			"Create","Delete",
			"CreateReadMe",
			"Releases","Deployments"
			}
		}
	]


GitHub[
	command_?(KeyMemberQ[$GitHubCalls,ToLowerCase@#]&),
	args___
	]:=
	Block[{$GitHubRepoFormat=True},
		Replace[$GitHubCalls[ToLowerCase@command][args],{
			h_HTTPRequest:>
				URLRead[h]
			}]
		];


GitHub[
	path:{___String}|_String:{},
	query:(_String->_)|{(_String->_)...}:{},
	headers:_Association:<||>
	]:=
	Block[{$GitHubRepoFormat=True},
		URLRead[
			GitHubQuery[
				path,
				query,
				headers
				]
			]
		];


(* ::Subsubsection::Closed:: *)
(*GitHubImport*)



GitHubImport[a_Association]:=
	Association@
		KeyValueMap[
			StringReplace[
				StringJoin[
					Capitalize/@StringSplit[#,"_"]
					],{
				"Id"~~EndOfString->"ID",
				"Url"->"URL",
				"Html"->"HTML"
				}]->
				Which[
					StringEndsQ[#,"_at"],
						DateObject@#2,
					StringEndsQ[#,"url"],
						URL[#2],
					True,
						GitHubImport@#2
					]&,
		a
		];
GitHubImport[h_HTTPResponse]:=
	<|
		"StatusCode"->
			h["StatusCode"],
		"Content"->
			If[MatchQ[h["StatusCode"],0|(_?(Between@{200,299}))],
				GitHubImport@Import[h,"RawJSON"],
				$Failed
				]
		|>;
GitHubImport[s_String]:=
	s;
GitHubImport[l_List]:=
	GitHubImport/@l;
GitHubImport[e_]:=
	e


GitHubImport[
	command_?(KeyMemberQ[$GitHubCalls,ToLowerCase@#]&),
	args__
	]:=
	GitHubImport@GitHub[command,args];
GitHubImport[
	path:{___String}|_String:{},
	query:(_String->_)|{(_String->_)...}:{},
	headers:_Association:<||>
	]:=
	GitHubImport@GitHub[path,query,headers];


End[];



