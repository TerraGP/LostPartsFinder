# LostPartsFinder

A simple PowerShell script to detect missing parts in multipart downloads made out of boredom. Newbie to PS, don't expect best practices but feel free to send any feedback.

It scans a folder for numerically indexed file parts (e.g. `.001`, `.002`, `.003`) and reports any missing segments in the sequence.

---

## Features

- Detects missing numbered file parts
- Automatic range detection
- Manual range support (`-Start`, `-End`)
- Compact output mode (`-Abbreviated`)

---

## Requirements

- PowerShell 5.1+ (Windows PowerShell)  
- PowerShell 7+ (recommended for cross-platform use)

---

## Usage

### Basic usage

```powershell
.\LostPartsFinder.ps1
```

Scans the current directory and detects missing parts automatically.

---

### Scan a specific folder

```powershell
.\LostPartsFinder.ps1 -TargetFolder "./downloads"
```

---

### Define a manual range

```powershell
.\LostPartsFinder.ps1 -Start 1 -End 100
```

Useful when you already know the expected sequence.

---

### Abbreviated output mode

```powershell
.\LostPartsFinder.ps1 -Abbreviated
```

Groups consecutive missing numbers into ranges.

#### Example output

```
Missing parts: 1..5, 8, 10..20
```

Without `-Abbreviated`:

```
Missing parts: 1, 2, 3, 4, 5, 8, 10, 11, 12...
```

---

## Example

### Input files

```
movie.001
movie.002
movie.003
movie.007
movie.008
movie.010
```

### Output

```
Missing parts: 4..6, 9
```

---

## Parameters

| Parameter        | Type   | Description |
|----------------|--------|-------------|
| `TargetFolder` | string | Folder to scan (default: current directory) |
| `Start`        | int    | Start of expected range |
| `End`          | int    | End of expected range |
| `Abbreviated`  | switch | Compress consecutive missing numbers |

---

## Notes

- Only files with numeric extensions are considered (`.001`, `.002`, etc.)
- The script assumes a continuous numeric sequence unless a range is specified

---

## Example scenarios

### Download interrupted archive

Useful for:

- multipart `.rar` / `.zip` archives
- incomplete batch downloads
