param (
    [switch]$System,
    [switch]$Disks,
    [switch]$Network
)

function Get-SystemReport {
    $systemInfo = Get-SystemInfo

    if (!$System -and !$Disks -and !$Network) {
        Write-Host "Operating System Information:"
        $systemInfo.OSInfo | Format-List

        Write-Host "Processor Information:"
        $systemInfo.ProcessorInfo | Format-List

        Write-Host "Memory Information:"
        $systemInfo.MemoryInfo | Format-Table -AutoSize -Property Manufacturer, PartNumber, Description, Capacity, BankLabel, DeviceLocator

        Write-Host "Video Card Information:"
        $systemInfo.VideoCardInfo | Format-Table -AutoSize -Property Vendor, Description, Resolution

        Write-Host "Disk Drive Information:"
        $systemInfo.DiskInfo | Format-Table -AutoSize -Property Manufacturer, Location, Drive, "Size(GB)", "Free Space(GB)", "% Free Space"

        Write-Host "Network Adapter Configuration:"
        $systemInfo.NetworkInfo | Format-Table -AutoSize -Property Description, Index, IPAddress, SubnetMask, DNSDomain, DNSServer
    }
    else {
        if ($System) {
            Write-Host "Operating System Information:"
            $systemInfo.OSInfo | Format-List

            Write-Host "Processor Information:"
            $systemInfo.ProcessorInfo | Format-List

            Write-Host "Memory Information:"
            $systemInfo.MemoryInfo | Format-Table -AutoSize -Property Manufacturer, PartNumber, Description, Capacity, BankLabel, DeviceLocator

            Write-Host "Video Card Information:"
            $systemInfo.VideoCardInfo | Format-Table -AutoSize -Property Vendor, Description, Resolution
        }

        if ($Disks) {
            Write-Host "Disk Drive Information:"
            $systemInfo.DiskInfo | Format-Table -AutoSize -Property Manufacturer, Location, Drive, "Size(GB)", "Free Space(GB)", "% Free Space"
        }

        if ($Network) {
            Write-Host "Network Adapter Configuration:"
            $systemInfo.NetworkInfo | Format-Table -AutoSize -Property Description, Index, IPAddress, SubnetMask, DNSDomain, DNSServer
        }
    }
}

Get-SystemReport
