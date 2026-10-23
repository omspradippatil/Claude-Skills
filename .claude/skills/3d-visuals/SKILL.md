---
name: 3d-visuals
description: >-
  Activate this skill for tasks involving Three.js, WebGL, shaders, 3D models,
  canvas rendering, or spatial visuals. Use when building interactive 3D web experiences,
  optimizing GPU memory, or rendering GLTF scenes.
---

# 3D Visuals & WebGL Engineering

> **Scope**: Three.js, React Three Fiber (R3F), GLSL shader programming, GLTF/GLB 3D model optimization, Draco compression, GPU draw call batching, memory lifecycle management, and spatial visual experiences.

---

## When to Activate

- Creating 3D product visualizers, interactive globes, or procedural canvas backgrounds
- Building Three.js or React Three Fiber (R3F) scenes
- Writing custom vertex and fragment shaders in GLSL
- Loading, optimizing, and animating GLTF/GLB models
- Debugging WebGL performance bottlenecks, memory leaks, and frame rate drops
- Implementing accessibility fallbacks for 3D canvas elements

---

## 1. WebGL Performance Fundamentals

### Draw Call Minimization
The primary bottleneck in WebGL is often CPU-to-GPU communication (draw calls), not raw polygon count.
- **InstancedMesh**: When rendering many identical geometries (e.g., thousands of particles, trees, or repetitive items), use `THREE.InstancedMesh` rather than creating individual `THREE.Mesh` instances. This renders thousands of objects in a single draw call.
- **Geometry Merging**: Merge static, non-moving geometries sharing the same material using `BufferGeometryUtils.mergeGeometries`.

### Texture & Memory Budget
- Always size textures to powers of two (POT: 512x512, 1024x1024, 2048x2048) for optimal GPU mipmapping.
- Prefer KTX2 / Basis Universal compressed textures over raw PNGs/JPEGs. KTX2 remains compressed directly in GPU VRAM, dramatically reducing mobile crash rates.
- Cap render target resolution on high-DPI displays:
  ```javascript
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2)); // Never exceed 2
  ```

---

## 2. GLTF / GLB 3D Model Optimization

### Pipeline Optimization
1. **Draco Compression**: Use Draco or Meshopt compression (`gltf-pipeline` or `gltfpack`) to reduce geometry file sizes by 70-90%.
2. **Remove Unused Attributes**: Strip unused vertex colors, secondary UV channels, and excessive bone weights.
3. **Decimation**: Simplify polygon density for web delivery. High-poly models belong in offline rendering, not mobile WebGL.

### Loading Strategy
Always load 3D assets asynchronously with a visible loading state or progressive disclosure:
```javascript
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader.js';
import { DRACOLoader } from 'three/examples/jsm/loaders/DRACOLoader.js';

const dracoLoader = new DRACOLoader();
dracoLoader.setDecoderPath('/draco/');

const loader = new GLTFLoader();
loader.setDRACOLoader(dracoLoader);

loader.load('/models/product.glb', (gltf) => {
  scene.add(gltf.scene);
}, onProgress, onError);
```

---

## 3. Strict WebGL Memory Management (Prevent Leaks)

JavaScript garbage collection DOES NOT automatically free WebGL GPU memory. Every geometry, material, texture, and render target MUST be explicitly disposed of:

```javascript
function cleanupObject(obj) {
  if (!obj) return;
  if (obj.geometry) {
    obj.geometry.dispose();
  }
  if (obj.material) {
    if (Array.isArray(obj.material)) {
      obj.material.forEach(cleanMaterial);
    } else {
      cleanMaterial(obj.material);
    }
  }
}

function cleanMaterial(material) {
  material.dispose();
  // Dispose all associated textures
  for (const key of Object.keys(material)) {
    const value = material[key];
    if (value && typeof value === 'object' && 'minFilter' in value) {
      value.dispose();
    }
  }
}

// In React / R3F, run cleanup on component unmount
```

---

## 4. Custom GLSL Shaders

### Shader Structure
- **Vertex Shader**: Handles coordinate transformations (model space → world space → view space → clip space). Keep calculations here rather than fragment shaders when values can be smoothly interpolated.
- **Fragment Shader**: Computes the final color per pixel. Avoid branching (`if/else`) inside inner loops; prefer GLSL math intrinsics (`mix`, `step`, `smoothstep`, `clamp`).

### Responsive Screen Coordinates & Aspect Ratio
Always pass viewport resolution to shaders to prevent distortion on resize:
```glsl
uniform vec2 u_resolution;
uniform float u_time;

void main() {
  vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / min(u_resolution.x, u_resolution.y);
  // Procedural shader logic...
}
```

---

## 5. Accessibility & Mobile Fallbacks

- Provide an accessible HTML description or static image fallback for users whose hardware or browser does not support WebGL or has hardware acceleration disabled.
- Pause the render loop (`cancelAnimationFrame`) when the canvas scrolls out of the viewport (using `IntersectionObserver`) to conserve user battery life:
  ```javascript
  const observer = new IntersectionObserver(([entry]) => {
    isCanvasVisible = entry.isIntersecting;
  });
  observer.observe(renderer.domElement);
  ```
- Disable heavy post-processing effects (bloom, depth of field, ambient occlusion) on low-power devices.
