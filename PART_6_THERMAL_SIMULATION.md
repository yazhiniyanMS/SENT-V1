## PART 6 — THERMAL SIMULATION

### lib/assets/shaders/thermal.frag
#ifdef GL_ES
precision mediump float;
#endif

varying vec2 vTextureCoord;
uniform sampler2D uImage;
uniform float uTime;

// Thermal color map: low intensity -> dark blue/purple -> blue -> green -> yellow -> orange -> red -> white/highlight
vec4 thermalColorMap(float luminance) {
    // We'll use a gradient that goes from dark blue to white via the specified colors.
    // We'll define the color stops:
    // 0.0: vec4(0.0, 0.0, 0.2, 1.0) // dark blue
    // 0.1: vec4(0.0, 0.0, 0.5, 1.0) // blue
    // 0.2: vec4(0.0, 0.5, 0.0, 1.0) // green
    // 0.3: vec4(0.5, 0.5, 0.0, 1.0) // yellow
    // 0.4: vec4(0.8, 0.3, 0.0, 1.0) // orange
    // 0.5: vec4(1.0, 0.0, 0.0, 1.0) // red
    // 0.6: vec4(1.0, 0.5, 0.0, 1.0) // bright orange
    // 0.7: vec4(1.0, 0.8, 0.0, 1.0) // lighter orange
    // 0.8: vec4(1.0, 0.9, 0.0, 1.0) // almost yellow
    // 0.9: vec4(1.0, 0.9, 0.5, 1.0) // pale yellow
    // 1.0: vec4(1.0, 1.0, 1.0, 1.0) // white

    // We'll interpolate between these stops.
    vec4 c0 = vec4(0.0, 0.0, 0.2, 1.0);
    vec4 c1 = vec4(0.0, 0.0, 0.5, 1.0);
    vec4 c2 = vec4(0.0, 0.5, 0.0, 1.0);
    vec4 c3 = vec4(0.5, 0.5, 0.0, 1.0);
    vec4 c4 = vec4(0.8, 0.3, 0.0, 1.0);
    vec4 c5 = vec4(1.0, 0.0, 0.0, 1.0);
    vec4 c6 = vec4(1.0, 0.5, 0.0, 1.0);
    vec4 c7 = vec4(1.0, 0.8, 0.0, 1.0);
    vec4 c8 = vec4(1.0, 0.9, 0.0, 1.0);
    vec4 c9 = vec4(1.0, 0.9, 0.5, 1.0);
    vec4 c10 = vec4(1.0, 1.0, 1.0, 1.0);

    float pos = luminance * 10.0; // Scale to 0-10
    int index = floor(pos);
    float fract = fract(pos);

    if (index >= 10) return c10;
    if (index < 0) return c0;

    vec4 cLow, cHigh;
    switch (index) {
        case 0: cLow = c0; cHigh = c1; break;
        case 1: cLow = c1; cHigh = c2; break;
        case 2: cLow = c2; cHigh = c3; break;
        case 3: cLow = c3; cHigh = c4; break;
        case 4: cLow = c4; cHigh = c5; break;
        case 5: cLow = c5; cHigh = c6; break;
        case 6: cLow = c6; cHigh = c7; break;
        case 7: cLow = c7; cHigh = c8; break;
        case 8: cLow = c8; cHigh = c9; break;
        case 9: cLow = c9; cHigh = c10; break;
        default: cLow = c0; cHigh = c10;
    }

    return mix(cLow, cHigh, fract);
}

void main() {
    // Sample the input image
    vec4 color = texture2D(uImage, vTextureCoord);
    // Convert to grayscale (luminance)
    float luminance = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    // Apply thermal color map
    vec4 thermalColor = thermalColorMap(luminance);
    // Output the thermal color
    gl_FragColor = thermalColor;
}

### Implementation Notes

The thermal simulation is implemented in the `ThermalView` widget, which uses a custom painter to apply a fragment shader to the video texture. The shader converts the video frame to grayscale and then maps the luminance values to a thermal color palette ranging from dark blue (low intensity) to white (high intensity), passing through blue, green, yellow, orange, and red.

The shader is loaded from `assets/shaders/thermal.frag` and passed a time uniform (`uTime`) to allow for potential animated effects (though the current implementation does not use time for the color mapping, it is available for future enhancements).

In the `ThermalView` widget, we attempt to load the shader from the asset. If the shader fails to load (e.g., due to compilation errors), we fall back to a linear gradient that approximates the thermal color palette.

The `ThermalView` is stacked on top of the `VideoPlayer` in the `LiveCameraCard` when the thermal simulation is enabled via the switch in the card's header.