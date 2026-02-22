$p = 8010
$l = [System.Net.HttpListener]::new()
$l.Prefixes.Add("http://localhost:$p/")
try {
    $l.Start()
    Write-Host "Server started at http://localhost:$p/"
    while ($l.IsListening) {
        $c = $l.GetContext()
        $r = $c.Request
        $s = $c.Response
        $localPath = $r.Url.LocalPath.TrimStart('/').Replace('/', '\')
        if ($localPath -eq "") { $localPath = "index.html" }
        $f = Join-Path "c:\Users\wijet\Downloads\stitch (2)\car sale" $localPath
        
        if (Test-Path $f -PathType Leaf) {
            $b = [IO.File]::ReadAllBytes($f)
            $ext = [System.IO.Path]::GetExtension($f)
            $contentType = switch ($ext) {
                ".html" { "text/html" }
                ".css" { "text/css" }
                ".js" { "application/javascript" }
                ".png" { "image/png" }
                ".jpg" { "image/jpeg" }
                default { "application/octet-stream" }
            }
            $s.ContentType = $contentType
            $s.ContentLength64 = $b.Length
            $s.OutputStream.Write($b, 0, $b.Length)
        } else {
            $s.StatusCode = 404
        }
        $s.Close()
    }
} finally {
    $l.Stop()
}
