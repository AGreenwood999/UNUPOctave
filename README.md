# 96well-assay-tools

Octave tools for loading, processing, and plotting 96-well plate
absorbance assay data.

## Currently supported
- Iron (Fe / Fe3O4) quantification via a standards-curve workflow

## Structure
- `inst/util/` — assay-agnostic helpers (well selection, name sanitizing)
- `inst/io/` — loading plate maps/raw data and computing concentrations
- `inst/plotting/` — plotting samples and standards curves onto an axis

As new assays are added, each gets its own `io`-style set of functions
(grouped in the INDEX file under its own category) while shared
utilities and plotting helpers stay common.

## Usage
```matlab
pkg load 96well-assay-tools
data = load_96well_plate_data("plate1.csv", "platemap.ods", stds_conc);
```

## Testing
Run `test <function_name>` in Octave for any function with embedded
`%!test` blocks (e.g. `test select_wells`).

## Development notes
Test cases, code comments/docstrings, and a handful of small bug
fixes (undefined variables, a function name mismatch, an off-by-one
in a shape check) in this package were written with AI assistance.
