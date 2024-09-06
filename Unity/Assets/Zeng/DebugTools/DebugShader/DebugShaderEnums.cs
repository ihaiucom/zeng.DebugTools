namespace Zeng.DebugShaders
{
    public enum SpaceType
    {
        ObjectSpace,
        WorldSpace,
    }
    
    public enum PositionSpaceType
    {
        ObjectSpace,
        WorldSpace,
        ViewSpace,
        ClipSpace,
        NDC,
    }

    public enum UVChannel
    {
        UV0,
        UV1,
        UV2,
        UV3,
        UV4,
        UV5,
        UV6,
        UV7
    }
    
    [System.Flags]
    public enum ShowAxis
    {
        X = 1,
        Y = 2,
        Z = 4,
        W = 8,
        XYZ = X | Y | Z,
        XYZW = X | Y | Z | W,
    }

    [System.Flags]
    public enum ShowUVAxis
    {
        X = 1,
        Y = 2,
        XY = X | Y,
    }
    
    
    [System.Flags]
    public enum ShowColorAxis
    {
        R = 1,
        G = 2,
        B = 4,
        A = 8,
        RGB = R | G | B,
        RGBA = R | G | B | A,
    }
}