
serviceDir=$PREFIX/var/service/
debOutDir=../../../../pool/main/

for d in $(ls $serviceDir) ;do
  packageDir=service-$d
  shebang=#!/data/data/com.termux/files/usr/bin/bash
  debianDir=$packageDir/DEBIAN
  downFile=$packageDir/$serviceDir/$d/down
  downf=$serviceDir/$d/down

  [[ -d $packageDir ]] || mkdir -pv $packageDir/$serviceDir/
  cp -radv $serviceDir/$d $packageDir/$serviceDir/
  rm -rf $packageDir/$serviceDir/$d/log/supervise/
  rm -rf $packageDir/$serviceDir/$d/supervise/
  [[ -f $downFile ]] || touch $downFile
  [[ -d $debianDir ]] || mkdir -pv $debianDir
  chmod 775 $debianDir

  echo "Package: $packageDir" > $debianDir/control
  echo "Version: 1.0" >> $debianDir/control
  echo "Section: base" >> $debianDir/control
  echo "Priority: optional" >> $debianDir/control
  echo "Architecture: all" >> $debianDir/control
  echo "Maintainer: fumei wwb.cici@gmail.com" >> $debianDir/control
  echo "Description: service [$packageDir]" >> $debianDir/control

  cat > $debianDir/postinst <<@
$shebang

read -p "Want to enable \\\`$d\\\` service now? [yes/y] : " -t10 -n3 isEn
if [[ \$isEn == yes || \$isEn == y ]] ;then
  [[ -f $downf ]] && rm $downf
else
  [[ -f $downf ]] || touch $downf
fi

@
  chmod 0775 $debianDir/postinst


  echo dpkg-deb --build $packageDir $debOutDir/$packageDir.deb
  dpkg-deb --build $packageDir $debOutDir/$packageDir.deb

done

exit


