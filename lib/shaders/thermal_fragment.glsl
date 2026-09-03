#extension GL_OES_EGL_image_external : require
#extension GL_OES_EGL_image_external_essl3 : require

precision mediump float;

uniform samplerExternalOES sTexture;
varying vec2 vTexCoord;

// Thermal color mapping function
vec3 thermalColor(float intensity) {
    // intensity: 0.0 (cold) to 1.0 (hot)
    vec3 color;

    if (intensity < 0.2) {
        // Cold: dark blue to blue
        color = vec3(0.0, 0.0, 0.5 + intensity * 2.5);
    } else if (intensity < 0.4) {
        // Cool: blue to light blue
        color = vec3(0.0, 0.0 + (intensity-0.2)*5.0, 1.0);
    } else if (intensity < 0.6) {
        // Medium: light blue to green
        color = vec3(0.0, 1.0, 1.0 - (intensity-0.4)*5.0);
    } else if (intensity < 0.8) {
        // Warm: green to yellow
        color = vec3(0.0 + (intensity-0.6)*5.0, 1.0, 0.0);
    } else {
        // Hot: yellow to red to white
        float hotIntensity = (intensity - 0.8) * 5.0;
        color = vec3(1.0, 1.0 - hotIntensity*0.5, 0.0 + hotIntensity*0.5);
    }

    return color;
}

void main() {
    // Get the video frame
    vec4 frame = texture2D(sTexture, vTexCoord);

    // Convert to grayscale for intensity calculation
    float intensity = dot(frame.rgb, vec3(0.299, 0.587, 0.114));

    // Apply thermal coloring
    vec3 thermal = thermalColor(intensity);

    // Output the thermal-colored frame
    gl_FragColor = vec4(thermal, frame.a);
}