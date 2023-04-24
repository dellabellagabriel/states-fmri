# States fMRI

## Folder structure

```
├── data
│   └── sub01
│       ├── session01-20230308
│       │   ├── dicom
│       │   ├── func-resting
│       │   ├── functional
│       │   │   ├── cond1
│       │   │   │   ├── nii
│       │   │   │   └── smooth
│       │   │   ├── cond2
│       │   │   │   ├── nii
│       │   │   │   └── smooth
│       │   │   ├── cond3
│       │   │   │   ├── nii
│       │   │   │   └── smooth
│       │   │   └── cond4
│       │   │       ├── nii original
│       │   │       └── smooth
│       │   └── structural
│       ├── session02-20230315
│       │   ├── dicom
│       │   ├── func-resting
│       │   ├── functional
│       │   │   ├── cond1
│       │   │   │   ├── nii
│       │   │   │   └── smooth
│       │   │   ├── cond2
│       │   │   │   ├── nii
│       │   │   │   └── smooth
│       │   │   ├── cond3
│       │   │   │   ├── nii
│       │   │   │   └── smooth
│       │   │   └── cond4
│       │   │       ├── nii
│       │   │       └── smooth
│       │   └── structural
│       ├── session03-20230327
│       │   ├── dicom
│       │   ├── func-resting
│       │   ├── functional
│       │   │   ├── cond1
│       │   │   │   ├── nii
│       │   │   │   └── smooth
│       │   │   ├── cond2
│       │   │   │   ├── nii
│       │   │   │   └── smooth
│       │   │   ├── cond3
│       │   │   │   ├── nii
│       │   │   │   └── smooth
│       │   │   └── cond4
│       │   │       ├── nii
│       │   │       └── smooth
│       │   └── structural
│       ├── session04-20230403
│       │   ├── dicom
│       │   ├── func-resting
│       │   ├── functional
│       │   │   ├── cond1
│       │   │   │   ├── nii
│       │   │   │   └── smooth
│       │   │   ├── cond2
│       │   │   │   ├── nii original
│       │   │   │   └── smooth
│       │   │   ├── cond3
│       │   │   │   ├── nii original
│       │   │   │   └── smooth
│       │   │   └── cond4
│       │   │       ├── nii original
│       │   │       └── smooth
│       │   └── structural
│       ├── session05-20230410
│       │   ├── dicom
│       │   ├── func-resting
│       │   ├── functional
│       │   └── structural
│       ├── session06-20230418
│       │   ├── dicom
│       │   ├── func-resting
│       │   ├── functional
│       │   └── structural
│       └── session07-20230424
│           ├── dicom
│           ├── func-resting
│           ├── functional
│           └── structural
├── results
│   └── seed
│       └── pcc_1_-61_38_5mm
│           └── statistics
└── scripts
    ├── preprocesamiento
    │   ├── conn
    │   │   └── fmri-resting-estados
    │   │       ├── data
    │   │       │   └── BIDS
    │   │       └── results
    │   │           ├── bookmarks
    │   │           ├── firstlevel
    │   │           │   ├── DYN_01
    │   │           │   ├── SBC_01
    │   │           │   └── V2V_01
    │   │           ├── preprocessing
    │   │           ├── qa
    │   │           └── secondlevel
    │   └── preprocessing_batchs
    └── seed
        └── masks
```

## Steps
- Run `scripts/preprocesamiento/dicom_to_nii.sh`
- Clean duplicate files in nii folder
- Default preprocessing pipeline in CONN (without regress out)
- Run `save_swr_before_regressout.m`
- Continue with the resting preprocessing in CONN
- Run `move_resting_from_conn_to_session.m`