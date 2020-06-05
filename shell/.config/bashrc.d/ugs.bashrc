# vim:set ft=sh et:

function svgToEps()
{
  if test $# -lt 1 ; then
    echo "You need to pass in a filename." ; return
  fi

  epsfile="${1%.*}.eps"

  echo "inkscape -f '$1' -E '$epsfile'"
  inkscape -f "$1" -E "$epsfile" >/dev/null 2>&1
}

function svgToDxf()
{
  if test $# -lt 1 ; then
    echo "You need to pass in a filename." ; return
  fi

  base="${1%.*}"
  epsfile="${base}.eps"
  dxffile="${base}.dxf"

  svgToEps "$1"
  echo "pstoedit -dt -f 'dxf:-polyaslines -mm' '${epsfile}' '${dxffile}'"
  pstoedit -dt -f 'dxf:-polyaslines -mm' "${epsfile}" "${dxffile}" >/dev/null 2>&1
  rm "$epsfile"
}
