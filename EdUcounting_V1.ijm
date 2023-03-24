// written by Dantong Liily Zhu Feb/27/2023
// Only works with .tiff files taken by revolve scope in our lab. This is written for EdU-Clickit results. 
  extension = ".tiff"; 
//Change extension here if you want to process other picture formats
  dir1 = getDirectory("Choose Source Directory ");
  setBatchMode(true);
  n = 0;
  processFolder(dir1);

  function processFolder(dir1) {
     list = getFileList(dir1);
     for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              processFolder(dir1+list[i]);
          else if (endsWith(list[i], extension))
             processImage(dir1, list[i]);
      }
  }

  function processImage(dir1, name) {
     open(dir1+name);
//this part is directly taken from https://imagej.net/scripting/batch
//image processing
run("Gaussian Blur...", "sigma=3");
run("Enhance Contrast...", "saturated=0.6");
//eliminate any background noise
run("Auto Threshold", "method=IsoData white");
//I found this auto threshold worked the best for my images
run("Watershed");
//segment conjoining cells
run("Analyze Particles...", "size=3500-Infinity circularity=0.30-1.00 show=Outlines summarize");
//eliminate any incorrectly segmented objects or background noise
//run("Analyze Particles...", "size=3000-Infinity circularity=0.15-1.00 show=Outlines display exclude summarize");
//an alternative setting if the setting above is not correctly