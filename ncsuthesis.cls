 \NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ncsuthesis}[2012/01/26 v0.4 NC State ETD conformant thesis class]

%%Thesis type
\newcommand{\ncsu@thesistype}{phd}
\DeclareOption{phd}{\renewcommand{\ncsu@thesistype}{phd}}
\DeclareOption{ms}{\renewcommand{\ncsu@thesistype}{ms}}

%% Spacing options
\newcommand{\ncsu@defaultspacing}{\onehalfspacing}
\DeclareOption{singlespacing}{
     \renewcommand{\ncsu@defaultspacing}{\singlespacing}}
\DeclareOption{onehalfspacing}{
     \renewcommand{\ncsu@defaultspacing}{\onehalfspacing}}
\DeclareOption{doublespacing}{
     \renewcommand{\ncsu@defaultspacing}{\doublespacing}}

\newenvironment{lscape}{\begin{lscapenum}}{\end{lscapenum}}
\DeclareOption{hardcopy}{
    \renewenvironment{lscape}{\begin{lscapenotnum}}{\end{lscapenotnum}}
}

\DeclareOption{draft}{\PassOptionsToClass{\CurrentOption}{book}}
\DeclareOption{10pt}{\PassOptionsToClass{\CurrentOption}{book}}
\DeclareOption{11pt}{\PassOptionsToClass{\CurrentOption}{book}}
\DeclareOption{12pt}{\PassOptionsToClass{\CurrentOption}{book}}

\DeclareOption*{\PackageWarning{ncsuthesis}{Unknown option `\CurrentOption'. Ignoring}}
\ExecuteOptions{phd,onehalfspacing} % the default option is <phd, onehalfspacing>
\ProcessOptions
\LoadClass[openany,oneside,titlepage,letterpaper]{book}

\RequirePackage{setspace}
\RequirePackage{hyphenat}
\RequirePackage{nolbreaks}
\RequirePackage{ifthen}
\RequirePackage{sectsty}
\RequirePackage{tocloft}
\RequirePackage{graphicx}
\RequirePackage[nottoc]{tocbibind} % includes lof, lot, refs in toc
\RequirePackage{calc}
\RequirePackage{xurl} % Allows long URLs and DOIs to line-break anywhere

%% Formatting Options
%% Capital letter height
\newlength{\ncsu@capitalheight}
\settoheight{\ncsu@capitalheight}{D}

%% Line height
\newlength{\ncsu@lineheight}
\setlength{\ncsu@lineheight}{2.0ex}

%% Leading height: The leading changes thoughout the document, so this
%%  length must be updated
\newlength{\ncsu@leading}

%% We must add two double spaces plus one capital-height (for the page number)
%%  to footskip.  Footskip is measured from the top of the bottom margin.
%%  (See geometry package documentation, note that includefoot option is used.)
\ncsu@defaultspacing
\RequirePackage[margin=1in,
                footskip=0.5in]{geometry}

\newcommand{\makeauthorshipstatementpage}{%
  \clearpage
  \thispagestyle{plain} % Ensures page number appears at bottom like other front matter
  
  %% 1. Manually add to Table of Contents
  \phantomsection 
  \addcontentsline{toc}{chapter}{Authorship Statement}

  %% 2. Manual Header (Matches Abstract size/style, but stays at 1-inch margin)
  \begin{center}
    \large \bfseries \MakeUppercase{Authorship Statement}
  \end{center}

  \vspace{1em} % Spacing between title and body text

  \begin{doublespacing}
    \noindent
    Contributions of Hasibul Hossain Rasheeq and coauthors are listed below for each chapter:

    \vspace{0.5em}

    \noindent \textbf{Chapter 1} \\
    1. Hasibul Hossain Rasheeq: sole author of Chapter 1.

    \vspace{0.5em}

    \noindent \textbf{Chapter 2} \\
    1. Hasibul Hossain Rasheeq: primary author. \\
    2. Asmaa Farag, Egemen Aras, and Arjun Earthperson: thesis manuscripts and conference papers of these authors guided the literature review.

    \vspace{0.5em}

    \noindent \textbf{Chapter 3} \\
    1. Hasibul Hossain Rasheeq: sole author of Chapter 3.

    \vspace{0.5em}

    \noindent \textbf{Chapter 4} \\
    1. Hasibul Hossain Rasheeq: primary author. \\
    2. Arjun Earthperson: conceptualized the microservice based architecture.

    \vspace{0.5em}

    \noindent \textbf{Chapter 5} \\
    1. Hasibul Hossain Rasheeq: primary author. \\
    2. Arjun Earthperson: helped with the boilerplate setup and cluster based implementation. \\
    3. Kirill Shumilov: provided insights on resource optimization for container based deployments.

    \vspace{0.5em}

    \noindent \textbf{Chapter 6} \\
    1. Hasibul Hossain Rasheeq: primary author. \\
    2. Kirill Shumilov: helped with the visualization of asynchronous distributed execution results.

    \vspace{0.5em}

    \noindent \textbf{Use of generative artificial intelligence:} \\
    The author has utilized the Gemini 3 Pro model for editing purposes, including grammar checking, sentence structure refinement, and ensuring clarity of expression. The intellectual work, including but not only limited to design, implementation, analysis, and argumentation remains solely the product of the author.

    \vfill
  \end{doublespacing}
  \clearpage
}

%% -------------------------------------------------------------------------- %%
%% Disposition format -- any titles, headings, section titles
\newcommand{\ncsu@dispositionformat}{}
\allsectionsfont{\ncsu@dispositionformat}
\providecommand{\dispositionformat}[1]{
    \renewcommand{\ncsu@dispositionformat}{#1}
    \allsectionsfont{\ncsu@dispositionformat}
}

%% Heading/Chapter/Section format
\newcommand{\ncsu@headingformat}{\ncsu@dispositionformat}
\providecommand{\headingformat}[1]{
    \renewcommand{\ncsu@headingformat}{\ncsu@dispositionformat #1}
}

%% \chapter*-to-first line space
%% This applies to preliminary headings, and ToC, LoF, LoT
\newlength{\ncsu@afterschapsep}
\setlength{\ncsu@afterschapsep}{3\ncsu@lineheight}

%% -------------------------------------------------------------------------- %%
%% Headers/footers - page number
\pagestyle{plain}

%% -------------------------------------------------------------------------- %%
%% Vertical space around tables and figures, triple spacing
\setlength{\textfloatsep}{3\ncsu@lineheight}
\setlength{\intextsep}{3\ncsu@lineheight}

%%----------------------------------------------------------------------------%%
%%---------------------------  Content Options -------------------------------%%
%% -------------------------------------------------------------------------- %%
%% Author name
\newcommand{\ncsu@authorfirstmiddle}{First Middle}
\newcommand{\ncsu@authorlast}{Last}

%% Command to test for period after middle name
\newboolean{@ncsu@needsperiod}
\newcommand{\ncsu@testlastchar}[2]{%
    \ifthenelse{\equal{#2}{\relax}}{
        \ifthenelse{\equal{#1}{.}}{%
            \setboolean{@ncsu@needsperiod}{false}
        }{% #1 != .
            \setboolean{@ncsu@needsperiod}{true}
        }
        \let\next=\relax
    }
    {% #2 != relax
        \let\next=\ncsu@testlastchar
    }
    \next#2
}

\providecommand{\student}[2]{
    \renewcommand{\ncsu@authorfirstmiddle}{#1}
    \renewcommand{\ncsu@authorlast}{#2}
    \ncsu@testlastchar#1\relax
    \author{\ncsu@authorfirstmiddle{} \ncsu@authorlast}
}

%% -------------------------------------------------------------------------- %%
%% Thesis Title
\newcommand{\ncsu@thesistitle}{My Thesis Title}
\providecommand{\thesistitle}[1]{\renewcommand{\ncsu@thesistitle}{#1}}

%% -------------------------------------------------------------------------- %%
%% ---------------------  Chapter Commands ---------------------------------- %%
%% -------------------------------------------------------------------------- %%

%% -------------------------------------------------------------------------- %%
%%  Redefine the \chapter* driver \@makeschapterhead. This is used for the
%%   preliminary headings.
%%   The spacing between the title baseline and the top of capital letters on
%%   the first line is specified by \ncsu@afterschapsep. However, this vertical
%%   height built by two separate lengths:
%%       1. the space between the baseline of the title and the top of the
%%           first line (including leading above the line).
%%              (\ncsu@afterschapbeforeleadingsep)
%%       2. From the top of the first line leading to the top of
%%           capital letters on the first line. (\ncsu@leading)
\newlength{\ncsu@afterschapbeforeleadingsep}
\AtBeginDocument{% at begin doc is necessary since fncychap
                 %  redefines \@makeschapterhead
    \renewcommand{\@makeschapterhead}[1]{%
        % Measure the leading here (which depends on the current line spacing),
        % and adjust the spacing accordingly between the baseline of the
        % heading and the top of capital letters on the first line.
        \setlength{\ncsu@leading}{\baselineskip-\ncsu@capitalheight}%
        \setlength{\ncsu@afterschapbeforeleadingsep}%
                  {\ncsu@afterschapsep-\ncsu@leading}%
        {\noindent\centering%
          {\ncsu@headingformat #1}%
          \par\nobreak%
          \vspace{\ncsu@afterschapbeforeleadingsep}}%
    }
}




%% -------------------------------------------------------------------------- %%
%% Abstract page commands
%%  - hyphnat package \nohyphens prevents title from being hyphenated.
%%  - \nolbreaks removes any line breaks in title (but you must use \linebreak
%%     instead of \\
\newcommand{\abstractname}{Abstract}
\newenvironment{abstract}{%
   \singlespacing
   \titlepage
   \chapter*{\abstractname}
   \MakeUppercase{\ncsu@authorlast{}, \ncsu@authorfirstmiddle{}}%
   \ifthenelse{\boolean{@ncsu@needsperiod}}{\@. }{~}%
    \nohyphens{\nolbreaks{\ncsu@thesistitle}.
   (Under the direction of
   \ifthenelse{\equal{\ncsu@chairtype}{chair}}%
              {\ncsu@chair}{\ncsu@cochairI\ and \ncsu@cochairII}).}\\

   \ncsu@defaultspacing
   \thispagestyle{empty}
   \pagestyle{empty}
}%
{\endtitlepage \pagestyle{plain}}

%% -------------------------------------------------------------------------- %%
%% Chair / co-chair commands (used only by the abstract page header).
\newcommand{\ncsu@chairtype}{}

\newcommand{\ncsu@chair}{Advisor Q. Chair}
\providecommand{\chair}[1]{
    \renewcommand{\ncsu@chair}{#1}
    \renewcommand{\ncsu@chairtype}{chair}
}

\newcommand{\ncsu@cochairI}{Co-chair 1 of Committee}
\providecommand{\cochairI}[1]{
    \renewcommand{\ncsu@cochairI}{#1}
    \renewcommand{\ncsu@chairtype}{cochair}
}

\newcommand{\ncsu@cochairII}{Co-chair 2 of Committee}
\providecommand{\cochairII}[1]{
    \renewcommand{\ncsu@cochairII}{#1}
    \renewcommand{\ncsu@chairtype}{cochair}
}

%% -------------------------------------------------------------------------- %%
%% ------------ Dedication, biography, and acknowledgements ----------------- %%
%% -------------------------------------------------------------------------- %%
%%  Template
\newcommand{\ncsu@dedbioack}[1]{%
    \chapter*{#1}%
}

%%  Dedication
\newcommand{\dedicationtitle}{Dedication}
\newenvironment{dedication}
{\ncsu@dedbioack{\dedicationtitle}}
{\clearpage}

%%  Biography
\newcommand{\biographytitle}{Biography}
\newenvironment{biography}
{\ncsu@dedbioack{\biographytitle}}
{\clearpage}

%%  Acknowledgements
\newcommand{\acknowledgementstitle}{Acknowledgements}
\newenvironment{acknowledgements}
{\ncsu@dedbioack{\acknowledgementstitle}}
{\clearpage}

%% -------------------------------------------------------------------------- %%
%% -------------------------  Table of Contents ----------------------------- %%
%% -------------------------------------------------------------------------- %%
\renewcommand{\contentsname}{Table of Contents}
\settowidth{\cftchapnumwidth}{\textbf{Chapter 00}}
\renewcommand{\cftchappresnum}{Chapter }
\renewcommand{\cftchapleader}{\cftdotfill{\cftsecdotsep}}
\newcommand{\thesistableofcontents}{%
    \singlespacing%
    \setlength{\cftbeforetoctitleskip}{-\baselineskip}
    \setlength{\ncsu@leading}{\baselineskip-\ncsu@capitalheight}%
    \setlength{\cftaftertoctitleskip}%
              {\ncsu@afterschapsep-\cftbeforechapskip-\ncsu@leading}%
    \tableofcontents%
    \clearpage%
    \ncsu@defaultspacing%
}
%% tocloft typesets ToC title, so we must give it our heading formats
%\renewcommand{\cfttoctitlefont}{\hfill\ncsu@headingformat}
%\renewcommand{\cftaftertoctitle}{\hfill}
\renewcommand{\cfttoctitlefont}{\hspace*{\fill}\ncsu@headingformat}
\renewcommand{\cftaftertoctitle}{\hspace*{\fill}}

\renewcommand{\listfigurename}{List of Figures}
\settowidth{\cftfignumwidth}{Figure 00.00}
\renewcommand{\cftfigpresnum}{Figure }
\newcommand{\thesislistoffigures}{%
    \singlespacing%
    \setlength{\cftbeforeloftitleskip}{-\baselineskip}
    \setlength{\ncsu@leading}{\baselineskip-\ncsu@capitalheight}%
    \setlength{\cftafterloftitleskip}%
              {\ncsu@afterschapsep-\cftbeforechapskip-\ncsu@leading}%
    \listoffigures%
    \clearpage%
    \ncsu@defaultspacing%
}
\renewcommand{\cftloftitlefont}{\hfill\ncsu@headingformat}
\renewcommand{\cftafterloftitle}{\hfill}

\renewcommand{\listtablename}{List of Tables}
\settowidth{\cfttabnumwidth}{Table 00.00}
\renewcommand{\cfttabpresnum}{Table }
\newcommand{\thesislistoftables}{%
    \singlespacing%
    \setlength{\cftbeforelottitleskip}{-\baselineskip}
    \setlength{\ncsu@leading}{\baselineskip-\ncsu@capitalheight}%
    \setlength{\cftafterlottitleskip}%
              {\ncsu@afterschapsep-\cftbeforechapskip-\ncsu@leading}%
    \listoftables%
    \clearpage%
    \ncsu@defaultspacing%
}
\renewcommand{\cftlottitlefont}{\hfill\ncsu@headingformat}
\renewcommand{\cftafterlottitle}{\hfill}

%% -------------------------------------------------------------------------- %%
%% ------------------------- Landscape Pages  ------------------------------- %%
%% -------------------------------------------------------------------------- %%
%%  Loading pdflscape package for page rotation
\RequirePackage{pdflscape}
%%  Loading fancyhdr package to change page numbering
\RequirePackage{fancyhdr}
%%  Loading sideways for sideways environment
\RequirePackage{rotating}

\newlength{\portraittextheight}
\setlength{\portraittextheight}{\textheight}
\addtolength{\portraittextheight}{\footskip}
\newlength{\portraittextwidth}
\setlength{\portraittextwidth}{\textwidth}

\RequirePackage{afterpage}
\RequirePackage{changepage}

%% Rotate page and page number
\newenvironment{lscapenum}
{
%%   The standard landscape environment does not rotate the margins and
%%   page number.  However, we want the margins (mostly) rotated as well
%%   as the page number.  To change the margins, we use the \changepage
%%   command from the \changepage package.  Since the \textheight and
%%   \textwidth dimensions get switched, we need to reduce the rotated
%%   \textheight by \ncsu@footskip and increase the \textwidth by the
%%   same measure.
%%
%%   The syntax of the \changepage command is
%% \changepage{textheight}{textwidth}{evensidemargin}{oddsidemargin}{columnsep}
%%            {topmargin}{headheight}{headsep}{footskip}
   \clearpage
   \changepage{\ncsu@footskip}{-\ncsu@footskip}{}{}{}{}{}{}{}
   \begin{landscape}
     \pagestyle{fancy}
     \fancyhead{} % clear all header fields
     \fancyfoot{} % clear all footer fields
     \renewcommand{\headrulewidth}{0pt}
     \rfoot{
       %% Since the header and footer are unrotated, we must manually
       %% place the page number.  The picture environment is included in
       %% standard LaTeX.
       \setlength{\unitlength}{\portraittextheight}
       \begin{picture}(0,0)
           \put(0.055,0.557){\begin{sideways}\thepage\end{sideways}} % page number
       \end{picture}
     }

}
{
   \end{landscape}
   %% The \textheight is too large leaving landscape environment
   %%  since we invoked the \changepage.  We manually reduce it.
   \addtolength{\textheight}{-\ncsu@footskip}

   %% \textheight controls 3 other variables, which must be updated.
   %% See \endlandscape definition in lscape.sty
   \global\@colht=\textheight
   \global\vsize=\textheight
   \global\@colroom=\textheight

   \pagestyle{plain}
}

%% Rotate page but NOT page number
\newenvironment{lscapenotnum}
{
   \begin{landscape}
}
{
   \end{landscape}
}

%% -------------------------------------------------------------------------- %%
%% ---------------------------  Captions      ------------------------------- %%
%% -------------------------------------------------------------------------- %%
%%  Adding space to start of caption
%%   save
\RequirePackage{caption}
\DeclareCaptionLabelSeparator{colon}{:\hspace{0.8em}}

%% -------------------------------------------------------------------------- %%
%% -------------------------  References ------------------------------------ %%
%% -------------------------------------------------------------------------- %%
\renewcommand{\bibname}{References}
%% natbib redefines \thebibliography, so we add our own requirements
%% at \begin{document} time.
\AtBeginDocument{
    \let\ncsu@thebibliography\thebibliography
    \let\endncsu@thebibliography\endthebibliography
    \renewenvironment{thebibliography}[1]
    {
        \singlespacing
        \sloppy % Forces text to stay inside margins, even if word spacing gets weird
        \begin{ncsu@thebibliography}{#1}
    }
    {
        \end{ncsu@thebibliography}
        \ncsu@defaultspacing
    }
}




%% -------------------------------------------------------------------------- %%
%% ------------------------- The Appendices  -------------------------------- %%
%% -------------------------------------------------------------------------- %%

\newlength{\appendixwidth}
\settowidth{\appendixwidth}{APPENDIX A}
\addtolength{\appendixwidth}{1em}
\providecommand{\appendixheader}[1]{
    \renewcommand{\ncsu@appendixheader}{#1}
}

%% Count the total number of appendices
\RequirePackage{totcount}
\regtotcounter{chapter} % chapter counter is used for appendices

\AtBeginDocument{%
%% Since ETD requirements are different than LaTeX's normal formatting of
%% the Table of Content's Appendix listings,
%% we change the indentation of chapters, sections, and subsections in
%% the appendix part of the table of contents, but no deeper divisions,
%% so we must cap the tocdepth at 2:
\newcounter{ncsu@appendixtocdepth}
\ifthenelse{\c@tocdepth > 2}
{\setcounter{ncsu@appendixtocdepth}{2}}
{\setcounter{ncsu@appendixtocdepth}{\c@tocdepth}}

\let\ncsu@appendix\appendix
\renewcommand{\appendix}{
    \ifthenelse{\isundefined{\ncsu@appendixheader}}
    % Appendix title page heading not defined, define it
    {
        \ifthenelse{\totvalue{chapter} = 1 }%
        %% number of appendices = 1
        {\newcommand{\ncsu@appendixheader}{APPENDIX}}
        %% number of appendices > 1
        {\newcommand{\ncsu@appendixheader}{APPENDICES}}
    }
    % Appendix title page heading already defined, do nothing
    {}

    \chapter*{\ncsu@appendixheader} %% insert 'Appendix' titlepage
    \addcontentsline{toc}{chapter}{\ncsu@appendixheader}
    %% Adding "Appendix" before letter in TOC
    %%  We must change the width of the box which the appendix letter is set in
    %%  and add the "Appendix " before the letter.  See tocloft documentation.
    \addtocontents{toc}{
        \protect\renewcommand{\protect\cftchappresnum}{Appendix }
        \protect\renewcommand{\protect\cftchapnumwidth}{\protect\appendixwidth}
        \protect\renewcommand{\protect\cftchapfont}{\protect\cftsecfont}
        \protect\setlength{\protect\cftbeforechapskip}{\protect\cftbeforesecskip}
        \protect\setlength{\protect\cftchapindent}{\protect\cftsecindent}
        \protect\renewcommand{\protect\cftchappagefont}{\protect\cftchapfont}
        \protect\setlength{\protect\cftsecindent}{\protect\cftsubsecindent}
        \protect\addtolength{\protect\cftsubsecindent}{\cftsecnumwidth}
        \protect\setcounter{tocdepth}{\c@ncsu@appendixtocdepth}
    }
    \clearpage
    \ncsu@appendix %% call internal \appendix macro
} % \renewcommand{appendix}
} % \AtBeginDocument

\ncsu@defaultspacing
%% End of file `ncsuthesis.cls'.
