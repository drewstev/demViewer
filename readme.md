  demViewer - Efficient viewing and exploring of large DEMs
  
    demViewer is a tool to view and explore large DEMs (Digital Elevation
    Models). The display  resolution changes dynamically to allow for
    efficient viewing of large DEMs. For broad spatial extents, the view
    resolution will be low.  Increased resolution is achieved by zooming
    into smaller areas.
 
    demViewer is a GUI that accepts no inputs. The user must first Open or
    Import a data file.  Currently, demViewer is only capable of importing
    DEMs in ARC Ascii format.  During the Import process, demViewer
    converts ARC Ascii file to netCDF with three fields (x, y, z) and a few
    user-supplied attributes about the DEM. demViewer works with both 
    projected (cartesian) grids as well as those in spherical coordinates 
    but has not been tested extensively with grids in spherical
    coordinates. NetCDF files previously imported by demViewer can be 
    displayed directly using the OPEN menu and supports data in Bathymetric 
    Attributed Grid (.bag) format.  
 
    APPEARANCE AND DISPLAY RESOLUTION - The appearance, including colormap,
    color limits, and hillshade effect is controlled using the 
    VIEW-> DEM Options menu. The display resolution  can be 
    adjusted using the EDIT->Set Maximum Pixels to Render option. A larger 
    number of pixels results in more resolution at a given zoom level, 
    but slower load time. 
 
    Navigation through the DEM is implemented with several self-explanatory
    view controls and view mouse inputs, below:
 
        'z' - zoom to a box z
        '+' - zoom in
        '-' - zoom out
        'f' - reset zoom to full extents
        'scroll wheel' - pan by pointing the mouse the direction where 
        you want to pan, then use the scroll wheel in either direction
 
    demViewer also allows the user to draw profiles and plot the elevations
    along the specified profiles. The elevations are derived from the 
    primary (highest) resolution of the DEM regardless of the zoom extent.
 
    EXPORT OPTIONS - THE DEM can be exported into .mat, .xyz, and .png
    file formats.  The exported data are provided at the current display
    resolution and spatial extent.
