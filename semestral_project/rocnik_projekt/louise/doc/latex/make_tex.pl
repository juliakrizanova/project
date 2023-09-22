:-module(make_tex, [make_tex/0
                   ]).

:-use_module(make_tex_configuration).

/** <module> Generate latex from structured documentation in Prolog files.

Usage instructions
------------------

1. Load this module from the louise root directory.

2. Set any directory paths etc you want in the configuration file for
this module: make_tex_configuration.pl. The defaults should be fine.

3. Call make_tex/0 to generate latex from the structured comments in
modules under the directories chosen in the configuration option
directories/2.

Generated Latex files are placed in the directory specified in the
configuration option tex_files_dir/2.

A 'main' documentation file is also generated, in the path given by
doc_file/1. By default ish this is called documentation.tex.

3. Pass the main documentation file to pdflatex to print out a pdf of
the module documentation. Call pdflatex _twice_ to ensure that the ToC
and bookmarks are generated. pdflatex will raise a few errors, but it
should nevertheless complete and write a full pdf at the output location
(I like to use a build/ subdirectory to keep things clean but that's
just me).

*/


%!      make_tex is det.
%
%       Create a latex file from modules' structured documentation.
%
make_tex:-
        directories(included,Ds)
        ,directories(excluded,Es)
        ,tex_files_dir(TD,_)
        ,make_directory_path(TD)
        ,documentation_files(Ds,Es,Fs)
        ,forall(member(P-F,Fs)
               ,(directory_file_path(TD,F,P_tex)
                ,doc_latex(P,P_tex,[stand_alone(false)])
                )
               )
        ,main_doc(Fs).


%!      documentation_files(+Included,+Excluded,-Files) is det.
%
%       Find paths to module files that must be documented.
%
%       Included is a list of directories to search for files with a
%       *.pl extension. Excluded is a list of directories to _not_
%       search for the same.
%
%       Files is a list of atoms representing paths to Prolog module
%       files whose structured documentation must be added to the latex
%       documents generated by make_tex.
%
documentation_files(Ds,Es,Fs):-
        findall(P-Fn_tex
               ,(member(D,Ds)
                ,directory_member(D,P,[recursive(true),extensions([pl])])
                ,directory_file_path(Rel_Dir,Fn,P)
                ,\+ member(Rel_Dir, Es)
                ,file_name_extension(Bn,_Ext,Fn)
                ,atomic_list_concat(Bn_,'_',Bn)
                ,atomic_list_concat(Bn_,'',Bn_fin)
                ,file_name_extension(Bn_fin,'.tex',Fn_tex)
                )
               ,Fs).


%!      main_doc(+Files) is det.
%
%       Write the main latex file documentation module documentation.
%
main_doc(Fs):-
        doc_file(F)
        ,tex_files_dir(_,Loc)
        ,doc_title(T)
        ,S = open(F,write,Strm,[alias(main_doc_file)])
        ,G = (format(Strm,'\\documentclass[11pt]{article}~n',[])
             ,format(Strm,'\\usepackage{times}~n',[])
             ,format(Strm,'\\usepackage{pldoc}~n',[])
             % Package hyperref already imported in pldoc.sty
             %,format(Strm,'\\usepackage[bookmarks=true]{hyperref}~n',[])
             ,format(Strm,'\\setcounter{tocdepth}{3}~n',[])
             ,format(Strm,'\\sloppy~n',[])
             % Indexing needs tagging of \index{key}'s. Nevermind.
             %,format(Strm,'\\makeindex~n',[])
             ,format(Strm,'\\title{~w}~n~n',[T])
             ,format(Strm,'\\begin{document}~n~n',[])
             ,format(Strm,'\\maketitle~n',[])
             ,format(Strm,'\\tableofcontents~n',[])
             ,format(Strm,'\\newpage~n~n',[])
             ,forall(member(_P-Fn,Fs)
                    ,(file_name_extension(Bn,_,Fn)
                     ,format(Strm,'\\input{~w/~w}~n',[Loc,Bn])
                     )
                    )
             ,format(Strm,'~n',[])
             %,format(Strm,'\\printindex~n',[])
             ,format(Strm,'\\end{document}',[])
             )
        ,C = close(Strm)
        ,setup_call_cleanup(S,G,C).
