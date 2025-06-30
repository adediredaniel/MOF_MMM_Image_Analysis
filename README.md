
# MOF_MMM_Image_Analysis

MATLAB script for stitching bright-field microscopy images and analyzing metal–organic framework (MOF) particle distribution in mixed-matrix membranes (MMMs).

---

## 📋 Description

This repository contains a MATLAB script (`MOF_MMM_Image_Analysis.m`) designed to:

- Stitch a grid of bright-field microscope images into a single composite image.
- Apply image processing (filtering and adaptive thresholding).
- Detect and classify individual MOF particles and particle clusters.
- Estimate total particle counts, including particles within clusters.
- Generate visual outputs including binary images, labeled color images, and cluster size histograms.

This script was developed as part of research on MOF–polymer interactions for MMMs using SPLIT.

---

## 🛠️ Requirements

- MATLAB (tested with R2021a and newer)
- Image Processing Toolbox
- Input image dataset structured as described below.

---

## 📂 Folder Structure

Example expected directory structure:

```
/[Current Working Directory]/
    /070824/
        /240/
            240_1_1_BF.png
            240_1_2_BF.png
            ...
            240_4_4_BF.png
```

Images should follow the naming format:  
`240_row_col_BF.png`, where `row` and `col` correspond to the grid positions (e.g., `1_1`, `1_2`, ..., `4_4`).

---

## ⚙️ Adjustable Parameters (Inside the Script)

- `gridSize` – Number of rows/columns in the image grid (default = 4×4)
- `imageFolder` – Path to the input image folder
- `minArea`, `maxArea` – Pixel area thresholds for single particle classification
- `clusterThreshold` – Minimum area for a region to be classified as a cluster

---

## ✅ How to Run

1. Open MATLAB.
2. Set your working directory to the folder containing the script.
3. Modify the `imageFolder` path at the top of the script if necessary.
4. Run the script:

```matlab
MOF_MMM_Image_Analysis
```

---

## 🖼️ Outputs

- Binary thresholded image
- Stitched composite image with grid overlay
- Color-labeled image (Green = single particles, Red = clusters)
- Histogram showing estimated particles per cluster
- Console output summarizing particle counts and size statistics

---

## 📄 License

This project is released under the MIT License.

---

## 👤 Author

Adedire Adesiji 
KABLab Boston University
30-Jun-2025

---

## ✅ Disclaimer

This script was developed for research purposes and may require modification for different image sets or experimental conditions.
