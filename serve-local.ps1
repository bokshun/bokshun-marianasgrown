param(
  [int]$Port = 8080
)

$root = (Get-Location).Path
$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Parse("127.0.0.1"), $Port)
$listener.Start()
Write-Host "Serving $root at http://127.0.0.1:$Port/"

$contentTypes = @{
  ".html" = "text/html; charset=utf-8"
  ".css" = "text/css; charset=utf-8"
  ".js" = "application/javascript; charset=utf-8"
  ".svg" = "image/svg+xml"
  ".png" = "image/png"
  ".jpg" = "image/jpeg"
  ".jpeg" = "image/jpeg"
  ".webp" = "image/webp"
}

function Send-Response($stream, [int]$status, [string]$statusText, [byte[]]$body, [string]$contentType) {
  $headers = "HTTP/1.1 $status $statusText`r`nContent-Length: $($body.Length)`r`nContent-Type: $contentType`r`nConnection: close`r`n`r`n"
  $headerBytes = [System.Text.Encoding]::ASCII.GetBytes($headers)
  $stream.Write($headerBytes, 0, $headerBytes.Length)
  if ($body.Length -gt 0) {
    $stream.Write($body, 0, $body.Length)
  }
}

while ($true) {
  $client = $listener.AcceptTcpClient()
  try {
    $stream = $client.GetStream()
    $reader = [System.IO.StreamReader]::new($stream, [System.Text.Encoding]::ASCII, $false, 1024, $true)
    $requestLine = $reader.ReadLine()

    if ([string]::IsNullOrWhiteSpace($requestLine)) {
      $client.Close()
      continue
    }

    $parts = $requestLine.Split(" ")
    $path = [Uri]::UnescapeDataString($parts[1].Split("?")[0].TrimStart("/"))
    if ([string]::IsNullOrWhiteSpace($path)) {
      $path = "index.html"
    }

    while (-not [string]::IsNullOrWhiteSpace($reader.ReadLine())) {}

    $fullPath = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($root, $path))
    if (-not $fullPath.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase)) {
      $body = [System.Text.Encoding]::UTF8.GetBytes("Forbidden")
      Send-Response $stream 403 "Forbidden" $body "text/plain; charset=utf-8"
      continue
    }

    if (-not [System.IO.File]::Exists($fullPath)) {
      $body = [System.Text.Encoding]::UTF8.GetBytes("Not found")
      Send-Response $stream 404 "Not Found" $body "text/plain; charset=utf-8"
      continue
    }

    $extension = [System.IO.Path]::GetExtension($fullPath).ToLowerInvariant()
    if ($contentTypes.ContainsKey($extension)) {
      $contentType = $contentTypes[$extension]
    } else {
      $contentType = "application/octet-stream"
    }

    $body = [System.IO.File]::ReadAllBytes($fullPath)
    Send-Response $stream 200 "OK" $body $contentType
  } finally {
    $client.Close()
  }
}
