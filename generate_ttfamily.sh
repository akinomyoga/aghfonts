#!/bin/bash

function generate-mf/setparam {
  local _suffix=
  if [[ $1 == -s* ]]; then
    _suffix=${1:2}
    shift
  fi

  # @param $1    parameter_name
  # @param $2-$4 values for different fontsizes
  # @param $5    value for Bold
  # @param $6    value for Bold Italic
  # @param $7    value for Small-caps

  case $fontsize in
  (8)  local _value=$2 ;;
  (9)  local _value=$3 ;;
  (10) local _value=$4 ;;
  (12) local _value=$5 ;;
  esac
  if [[ $_value != 1/sqrt2 ]]; then
    export fontsize
    _value=$(awk "
      BEGIN {
        opts = ENVIRON[\"opts\"];
        fontsize = ENVIRON[\"fontsize\"];
        height = 30 * fontsize;
        value = $_value;

        # 太字
        if ($6 != $4) {
          # 太字 bold, heavy
          if (opts ~ /:heavy:/)
            value += value * ($6 - $4) / $4 * 2.0;
          else if (opts ~ /:bold:/)
            value += value * ($6 - $4) / $4;
          else if (opts ~ /:light:/)
            value -= value * ($6 - $4) / $4 * 1.0;

          # 少し太くする
          if (match(opts, /:inflate([0-9]+):/, m))
            value += height * (m[1] / 1000) * ($6 - $4) / 5;
        }

        # italic
        if (opts ~ /:italic:/ && $7 != $6)
          value += ($7 - $6) * fontsize / 10;

        # Small-caps の補正
        if (opts ~ /:smallcaps:/ && $8 != 999 && $8 != $4)
          value += ($8 - $4) * fontsize / 10;

        printf(\"%.1f\", value);
        exit;
      }")
  fi
  [[ $_value != 0 ]] && _value=$_value$_suffix
  eval "$1=\$_value"
}
function generate-mf {
  # 以下の表の各列は以下のファイルを元にしている。
  #   amsfonts/cm/cmtt8.mf
  #   amsfonts/cm/cmtt9.mf
  #   amsfonts/cm/cmtt10.mf
  #   amsfonts/cm/cmtt12.mf
  #   cm-unicode-0.7.0/ectb.mf (Bold)
  #   cm-unicode-0.7.0/ectx.mf (Bold Italic)
  #   amsfonts/cm/cmtcsc10.mf  (Small-caps)
  #
  # 各行末尾のコメントにある記号は以下を表す。
  #   *1 ... cmtt10.mf 等には存在しなかった項目
  #   B  ... bold の時に修正が入っている項目
  #   I  ... italic の時に修正が入っている項目
  #   C  ... smallcsp の時に修正が入っている項目
  generate-mf/setparam -s/36pt u                  17    18.9      21    24.7        21   21 999 #
  generate-mf/setparam -s/36pt width_adj           0       0       0       0         0    0 999 #
  generate-mf/setparam -s/36pt serif_fit           0       0       0       0         0    0 999 #
  generate-mf/setparam -s/36pt cap_serif_fit       0       0       0       0         0    0 999 #
  generate-mf/setparam -s/36pt letter_fit          0       0       0       0         0   15 999 # I 0->15
  generate-mf/setparam -s/36pt body_height       200     225     250     300       250  250 999 #
  generate-mf/setparam -s/36pt asc_height        176     198     220     264       220  220 999 #
  generate-mf/setparam -s/36pt cap_height        176     198     220     264       220  220 999 #
  generate-mf/setparam -s/36pt fig_height        176     198     220     264       220  220 999 #
  generate-mf/setparam -s/36pt x_height          124   139.5     155     186       160  160 999 # B
  generate-mf/setparam -s/36pt math_axis          88      99     110     132       110  110 999 #
  generate-mf/setparam -s/36pt bar_height         63      71      79      95        77   77 999 #
  generate-mf/setparam -s/36pt comma_depth        40      45      50      60        50   50 999 #
  generate-mf/setparam -s/36pt desc_depth         64      72      80      96        80   80 999 #
  generate-mf/setparam -s/36pt acc_height         60    67.5      90      90        90   90 999 # *1 % 75
  generate-mf/setparam -s/36pt dot_height         60    67.5      66      90        66   66 999 # *1 % 75
  generate-mf/setparam -s/36pt udot_height      47.2    53.1      59    70.8        59   59 999 # *1 % 59
  generate-mf/setparam -s/36pt crisp              19      21      22      25        22   22 999 #
  generate-mf/setparam -s/36pt tiny               19      21      22      25        22   22 999 #
  generate-mf/setparam -s/36pt fine               18      20      21      22        21   21 999 #
  generate-mf/setparam -s/36pt thin_join          18      20      21      22        21   21 999 #   % !
  generate-mf/setparam -s/36pt hair               22      24      25      28        30   30 999 # B % !
  generate-mf/setparam -s/36pt stem               22      24      25      28        30   30 999 # B % !
  generate-mf/setparam -s/36pt curve              22      24      25      28        30   30 999 # B % !
  generate-mf/setparam -s/36pt ess                19      21      22      25        30   30 999 # B % !
  generate-mf/setparam -s/36pt flare              28      30      32      35        30   30 999 # B % !
  generate-mf/setparam -s/36pt dot_size           31      33      36      39        43   43 999 # B % !
  generate-mf/setparam -s/36pt cap_hair           22      24      25      28        30   30 999 # B % !
  generate-mf/setparam -s/36pt cap_stem           22      24      25      28        30   30 999 # B % !
  generate-mf/setparam -s/36pt cap_curve          22      24      25      28        30   30 999 # B % !
  generate-mf/setparam -s/36pt cap_ess            22      24      25      28        30   30 999 # B % !
  generate-mf/setparam -s/36pt rule_thickness     22      24      25      28        30   30 999 # B % !
  generate-mf/setparam -s/36pt dish                0       0       0       0         0    0 999 #
  generate-mf/setparam -s/36pt bracket             0       0       0       0         0    0 999 #
  generate-mf/setparam -s/36pt jut                27      31      34      39        34   40 999 # I 34->40
  generate-mf/setparam -s/36pt cap_jut            27      31      34      39        34   34 999 #
  generate-mf/setparam -s/36pt beak_jut            0       0       0       0         0    0 999 #
  generate-mf/setparam -s/36pt beak               27      31      34      39        34   34 999 #
  generate-mf/setparam -s/36pt vair               19      21      22      25        27   27 999 # B % !
  generate-mf/setparam -s/36pt notch_cut          22      24      25      28        25   25 999 #   % ? 40
  generate-mf/setparam -s/36pt bar                19      21      22      25        27   27 999 # B % !
  generate-mf/setparam -s/36pt slab               19      21      22      25        27   27 999 # B % !
  generate-mf/setparam -s/36pt cap_bar            19      21      22      25        27   27 999 # B % !
  generate-mf/setparam -s/36pt cap_band           19      21      22      25        27   27 999 # B % !
  generate-mf/setparam -s/36pt cap_notch_cut      22      24      25      28        25   25 999 #   % ? 55
  generate-mf/setparam -s/36pt serif_drop          0       0       0       0         0    0 999 #
  generate-mf/setparam -s/36pt stem_corr           0       0       0       0         0    0 999 #
  generate-mf/setparam -s/36pt vair_corr           0       0       0       0         0    0 999 #
  generate-mf/setparam -s/36pt apex_corr           8       9      10      11        11   11 999 #
  generate-mf/setparam -s/36pt o                   3     3.5       4       5         3    3 999 #
  generate-mf/setparam -s/36pt apex_o              3       3       3       4         2    2 999 #

  generate-mf/setparam fudge                    0.81    0.81    0.81    0.86      0.81 0.81 999
  generate-mf/setparam math_spread                -1      -1      -1      -1        -1   -1 999

  # unused
  true_mono=true

  generate-mf/setparam -s/36pt l_u                17    18.9      21    24.7     21   21   21 #
  generate-mf/setparam -s/36pt l_width_adj         0       0       0       0      0    0    0 #
  generate-mf/setparam -s/36pt l_cap_serif_fit     0       0       0       0      0    0    0 #
  generate-mf/setparam -s/36pt l_letter_fit        0       0       0       0      0   15    3 #  IC
  generate-mf/setparam -s/36pt l_body_height     200     225     250     300    250  250  190 #   C
  generate-mf/setparam -s/36pt l_cap_height      176     198     220     264    220  220  170 #   C
  generate-mf/setparam -s/36pt l_x_height        124   139.5     155     186    160  160  120 # B C
  generate-mf/setparam -s/36pt l_bar_height       63      71      79      95     77   77   62 #   C
  generate-mf/setparam -s/36pt l_comma_depth      40      45      50      60     50   50   38 #   C
  generate-mf/setparam -s/36pt l_flare            28      30      32      35     30   30   30 # B C
  generate-mf/setparam -s/36pt l_cap_hair         22      24      25      28     30   30   25 # B
  generate-mf/setparam -s/36pt l_stem             22      24      25      28     30   30   25 # B
  generate-mf/setparam -s/36pt l_cap_stem         22      24      25      28     30   30   25 # B
  generate-mf/setparam -s/36pt l_cap_curve        22      24      25      28     30   30   25 # B
  generate-mf/setparam -s/36pt l_cap_ess          22      24      25      28     30   30   25 # B
  generate-mf/setparam -s/36pt l_cap_jut          27      31      34      39     34   34   26 #   C
  generate-mf/setparam -s/36pt l_beak_jut          0       0       0       0      0    0    0 #
  generate-mf/setparam -s/36pt l_beak             27      31      34      39     34   34   26 #   C
  generate-mf/setparam -s/36pt l_slab             19      21      22      25     27   27   22 # B
  generate-mf/setparam -s/36pt l_cap_bar          19      21      22      25     27   27   22 # B
  generate-mf/setparam -s/36pt l_cap_band         19      21      22      25     27   27   22 # B
  generate-mf/setparam -s/36pt l_cap_notch_cut    22      24      25      28     25   25   24 #   C
  generate-mf/setparam -s/36pt l_o                 3     3.5       4       5      3    3    3 #   C
  generate-mf/setparam -s/36pt l_apex_o            3       3       3       4      2    2    2 #   C
  generate-mf/setparam         l_fudge          0.81    0.81    0.81    0.81   0.81 0.81 0.85 #

  local superness=1/sqrt2
  if [[ $opts == *:bold:* || $opts == *:heavy:* ]]; then
    superness=8/11
  fi

  local base_driver=roman slant=0 for_csc='%'
  if [[ $opts == *:italic:* ]]; then
    base_driver=textit slant=0.25
  elif [[ $opts == *:slant:* ]]; then
    slant=1/6
  elif [[ $opts == *:smallcaps:* ]]; then
    # Small-Caps は通常と全く同じで driver だけが異なる。
    base_driver=csc for_csc=
  fi

  cat << EOF > "$1"
% THIS IS UNOFFICIAL COMPUTER MODERN SOURCE FILE cmtt10.mf BY K MURASE.
% IT MUST NOT BE MODIFIED IN ANY WAY UNLESS THE FILE NAME IS CHANGED!

% Computer Modern Typewriter Text for use with 10 point
if unknown cmbase: input cmbase fi

font_identifier:="AGHTEX_CM${fontname^^}"; font_size 10pt#;

u#:=$u#;                            % unit width
width_adj#:=$width_adj#;            % width adjustment for certain characters
serif_fit#:=$serif_fit#;            % extra sidebar near lowercase serifs
cap_serif_fit#:=$cap_serif_fit#;    % extra sidebar near uppercase serifs
letter_fit#:=$letter_fit#;          % extra space added to all sidebars

body_height#:=$body_height#;        % height of tallest characters
asc_height#:=$asc_height#;          % height of lowercase ascenders
cap_height#:=$cap_height#;          % height of caps
fig_height#:=$fig_height#;          % height of numerals
x_height#:=$x_height#;              % height of lowercase without ascenders
math_axis#:=$math_axis#;            % axis of symmetry for math symbols
bar_height#:=$bar_height#;          % height of crossbar in lowercase e
comma_depth#:=$comma_depth#;        % depth of comma below baseline
desc_depth#:=$desc_depth#;          % depth of lowercase descenders

crisp#:=$crisp#;                    % diameter of serif corners
tiny#:=$tiny#;                      % diameter of rounded corners
fine#:=$fine#;                      % diameter of sharply rounded corners
thin_join#:=$thin_join#;            % width of extrafine details
hair#:=$hair#;                      % lowercase hairline breadth
stem#:=$stem#;                      % lowercase stem breadth
curve#:=$curve#;                    % lowercase curve breadth
ess#:=$ess#;                        % breadth in middle of lowercase s
flare#:=$flare#;                    % diameter of bulbs or breadth of terminals
dot_size#:=$dot_size#;              % diameter of dots
cap_hair#:=$cap_hair#;              % uppercase hairline breadth
cap_stem#:=$cap_stem#;              % uppercase stem breadth
cap_curve#:=$cap_curve#;            % uppercase curve breadth
cap_ess#:=$cap_ess#;                % breadth in middle of uppercase s
rule_thickness#:=$rule_thickness#;  % thickness of lines in math symbols

dish#:=$dish#;                      % amount erased at top or bottom of serifs
bracket#:=$bracket#;                % vertical distance from serif base to tangent
jut#:=$jut#;                        % protrusion of lowercase serifs
cap_jut#:=$cap_jut#;                % protrusion of uppercase serifs
beak_jut#:=$beak_jut#;              % horizontal protrusion of beak serifs
beak#:=$beak#;                      % vertical protrusion of beak serifs
vair#:=$vair#;                      % vertical diameter of hairlines
notch_cut#:=$notch_cut#;            % maximum breadth above or below notches
bar#:=$bar#;                        % lowercase bar thickness
slab#:=$slab#;                      % serif and arm thickness
cap_bar#:=$cap_bar#;                % uppercase bar thickness
cap_band#:=$cap_band#;              % uppercase thickness above/below lobes
cap_notch_cut#:=$cap_notch_cut#;    % max breadth above/below uppercase notches
serif_drop#:=$serif_drop#;          % vertical drop of sloped serifs
stem_corr#:=$stem_corr#;            % for small refinements of stem breadth
vair_corr#:=$vair_corr#;            % for small refinements of hairline height
apex_corr#:=$apex_corr#;            % extra width at diagonal junctions

o#:=$o#;                            % amount of overshoot for curves
apex_o#:=$apex_o#;                  % amount of overshoot for diagonal junctions

slant:=$slant;                      % tilt ratio \$(\Delta x/\Delta y)\$
fudge:=$fudge;                      % factor applied to weights of heavy characters
math_spread:=-1;                    % extra openness of math symbols
superness:=$superness;              % parameter for superellipses
superpull:=0;                       % extra openness inside bowls
beak_darkness:=0;                   % fraction of triangle inside beak serifs
ligs:=0;                            % level of ligatures to be included

square_dots:=false;                 % should dots be square?
hefty:=true;                        % should we try hard not to be overweight?
serifs:=true;                       % should serifs and bulbs be attached?
monospace:=true;                    % should all characters have the same width?
variant_g:=false;                   % should an italic-style g be used?
low_asterisk:=true;                 % should the asterisk be centered at the axis?
math_fitting:=false;                % should math-mode spacing be used?

% % additional parameters?
% acc_height#:=$acc_height#;   % unused?
% dot_height#:=$dot_height#;   % unused?
% udot_height#:=$udot_height#; % unused?
% true_mono:=$true_mono;

%------------------------------------------------------------------------------
% now come replacements used to set the lowercase caps
$for_csc
$for_csc lower.u#:=$l_u#;                         % unit width
$for_csc lower.width_adj#:=$l_width_adj#;         % width adjustment for certain characters
$for_csc lower.cap_serif_fit#:=$l_cap_serif_fit#; % extra sidebar near uppercase serifs
$for_csc lower.letter_fit#:=$l_letter_fit#;       % extra space added to all sidebars
$for_csc
$for_csc lower.body_height#:=$l_body_height#;     % height of tallest characters
$for_csc lower.cap_height#:=$l_cap_height#;       % height of caps
$for_csc lower.x_height#:=$l_x_height#;           % height of lowercase without ascenders
$for_csc lower.bar_height#:=$l_bar_height#;       % height of crossbar in lowercase e
$for_csc lower.comma_depth#:=$l_comma_depth#;     % depth of comma below baseline
$for_csc
$for_csc lower.flare#:=$l_flare#;                 % diameter of bulbs or breadth of terminals
$for_csc lower.cap_hair#:=$l_cap_hair#;           % uppercase hairline breadth
$for_csc lower.stem#:=$l_stem#;                   % lowercase stem breadth
$for_csc lower.cap_stem#:=$l_cap_stem#;           % uppercase stem breadth
$for_csc lower.cap_curve#:=$l_cap_curve#;         % uppercase curve breadth
$for_csc lower.cap_ess#:=$l_cap_ess#;             % breadth in middle of uppercase s
$for_csc
$for_csc lower.cap_jut#:=$l_cap_jut#;             % protrusion of uppercase serifs
$for_csc lower.beak_jut#:=$l_beak_jut#;           % horizontal protrusion of beak serifs
$for_csc lower.beak#:=$l_beak#;                   % vertical protrusion of beak serifs
$for_csc lower.slab#:=$l_slab#;                   % serif and arm thickness
$for_csc lower.cap_bar#:=$l_cap_bar#;             % uppercase bar thickness
$for_csc lower.cap_band#:=$l_cap_band#;           % uppercase thickness above/below lobes
$for_csc lower.cap_notch_cut#:=$l_cap_notch_cut#; % max breadth above/below uppercase notches
$for_csc
$for_csc lower.o#:=$l_o#;                         % amount of overshoot for curves
$for_csc lower.apex_o#:=$l_apex_o#;               % amount of overshoot for diagonal junctions
$for_csc
$for_csc lower.fudge:=$l_fudge;                   % factor applied to weights of heavy characters
$for_csc
%------------------------------------------------------------------------------

generate $base_driver                    % switch to the driver file
EOF
}

function generate-ttf {
  # MFTRACE=mftrace
  # export MFTRACE_OPTIONS="--magnification=2400 --formats=ttf --autotrace --noround --grid 1000"
  # export MFTRACE_BACKEND_OPTIONS="-filter-iterations 100 -corner-threshold 120 -error-threshold 0.3 -line-reversion-threshold 0.1  -tangent-surround 15 -remove-adjacent-corners"
  # $MFTRACE $MFTRACE_OPTIONS cmsltt10
  ( cd tmp; mftrace -e ../ec.enc --formats=ttf "$1" )
}

function modify-ttf {
  local input=$1 output=$2

  # FontForge Script にはフォント情報を設定する関数として以下の物がある。
  #   Open(filename[,flags])
  #   SetFontNames(fontname[,family[,fullname[,weight[,copyright-notice[,fontversion]]]]])
  #   CIDSetFontNames(fontname[,family[,fullname[,weight[,copyright-notice]]]])
  #   SetTTFName(lang,nameid,utf8-string)
  #   SetOS2Value(field-name,field-value)
  # SetTTFName に関しては以下を参照する。
  #   https://web.archive.org/web/20120326094610/https://partners.adobe.com/public/developer/opentype/index_name.html

  local copy='Copyright (c) 2019, akinomyoga <myoga.murase@gmail.com>'
  local version=4.0

  local ttffamily='aghtex Computer Modern Typewriter Text'
  local -a ttfsub=()
  [[ $opts == *:light:* ]] && ttfsub+=(Light)
  [[ $opts == *:bold:* ]] && ttfsub+=(Bold)
  [[ $opts == *:heavy:* ]] && ttfsub+=(Black)
  [[ $opts == *:slant:* ]] && ttfsub+=(Oblique)
  [[ $opts == *:italic:* ]] && ttfsub+=(Italic)
  [[ $opts == *:smallcaps:* ]] && ttfsub+=(Small-caps)
  ((${#ttfsub[@]})) || ttfsub+=(Regular)
  ttfsub="${ttfsub[*]}"

  local ttffull="$ttffamily $ttfsub"
  local ttfid=$key

  local os2weight=500
  [[ $opts == *:light:* ]] && os2weight=300
  [[ $opts == *:bold:*  ]] && os2weight=700
  [[ $opts == *:heavy:* ]] && os2weight=900

  local os2style=0
  [[ $opts == *:italic:* || $opts == *:slant:* ]] && let os2style++
  [[ $opts == *:bold:* ]] && let os2style+=0x20
  ((os2style)) || ((os2style=0x40))

  fontforge -lang=ff -script <<EOF
Open("$input")
SetFontNames("$key", "$ttffamily", "$ttffull", "$ttfsub", "$copy", "$version")
#CIDSetFontNames("$key", "$ttffamily", "$ttffull", "$ttfsub", "$copy")
SetTTFName(0x409, 0, "$copy")
SetTTFName(0x409, 1, "$ttffamily")
SetTTFName(0x409, 2, "$ttfsub")
SetTTFName(0x409, 3, "$ttfid")
SetTTFName(0x409, 4, "$ttffull")
SetTTFName(0x409, 5, "Version $version")
SetTTFName(0x409, 13, "The SIL Open Font License, Version 1.1.")
SetTTFName(0x409, 14, "http://scripts.sil.org/OFL")
SetOS2Value("Weight", $os2weight)
#SetOS2Value("StyleMap", $os2style)

# Automatical Adjustment
SelectWorthOutputting()
CanonicalContours()
CanonicalStart()
ClearHints()
AutoHint()
AutoInstr()

Generate("$output", "ttf", 0x200, -1)
EOF
}

function generate {
  local key=aghtex_cm$1
  local -x opts=:$2:

  [[ -s out/$key.ttf && $opts != *:force:* ]] && return

  local rex='^([a-z]*)([0-9]+)'
  [[ $1 =~ $rex ]] || return
  local fontname=${BASH_REMATCH[1]}
  local fontsize=${BASH_REMATCH[2]}

  [[ ${fontname:2:1} == b ]] && opts=:bold$opts
  [[ ${fontname:2:1} == h ]] && opts=:heavy$opts
  [[ ${fontname:2:1} == l ]] && opts=:light$opts
  [[ ${fontname:3} == s ]] && opts=:slant$opts
  [[ ${fontname:3} == c ]] && opts=:smallcaps$opts
  [[ ${fontname:3} == i ]] && opts=:italic$opts

  [[ -d out ]] || mkdir -p out
  [[ -d tmp ]] || mkdir -p tmp
  generate-mf "tmp/$key.mf"
  generate-ttf "$key"
  modify-ttf "tmp/$key.ttf" "out/$key.ttf"
}

#for key in tt{l,m,b,h}{n,c,s,i}{8,9,10,12}; do generate "$key"; done
for key in tt{l,m,b,h}{n,c,s,i}10; do generate "$key"; done
#for key in tt{m,b}{n,s,i}10; do generate "$key"; done
#for key in tt{m,b,h}{n,c,s,i}{8,9,10,12}; do generate "$key" inflate10; done
