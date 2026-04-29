function RGB(r, g, b)
    return { r / 255.0, g / 255.0, b / 255.0 }
end

-- based on https://lospec.com/palette-list/oil-6
-- 251	245	239	fbf5ef
-- 242	211	171	f2d3ab
-- 198	159	165	c69fa5
-- 139	109	156	8b6d9c
-- 73	77	126	494d7e
-- 39	39	68	272744
PALETTE = {
    lightest = RGB(251, 245, 239),
    lighter = RGB(242, 211, 171),
    light = RGB(198, 159, 165),
    mid = RGB(139, 109, 156),
    dark = RGB(73, 77, 126),
    darkest = RGB(39, 39, 68)
}
