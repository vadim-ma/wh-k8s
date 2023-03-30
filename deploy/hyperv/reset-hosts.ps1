#D:\hv\k8s-m3\m3-boot.vhdx

$dstpath="d:\hv\"
$srcvhd="d:\hv\Virtual Hard Disks\debian-11-genericcloud-amd64.vhdx"
$iso="cloud.iso"
$hosts=@("m1", "m2", "m3","w1", "w2", "w3")

foreach( $h in $hosts ){
    copy-item "${srcvhd}" (Join-Path "${dstpath}k8s-${h}" "${h}-boot.vhdx")
    Set-VMDvdDrive -VMName "k8s-${h}" -Path (Join-Path "${dstpath}k8s-${h}" "${iso}")
    Start-VM -VMName "k8s-${h}"
}
Start-Sleep -Seconds 30
foreach( $h in $hosts ){
    Stop-VM -VMName "k8s-${h}" -TurnOff
}
foreach( $h in $hosts ){
    Start-VM -VMName "k8s-${h}"
}
Start-Sleep -Seconds 30
foreach( $h in $hosts ){
    Stop-VM -VMName "k8s-${h}"
    Set-VMDvdDrive -VMName "k8s-${h}" -Path $null
    Start-VM -VMName "k8s-${h}"
}
