---
name: web-gamedev
description: >-
  Activate this skill for HTML5 canvas games, game loops, physics engines (Matter.js),
  sprite rendering, or interactive browser gaming experiences. Use when building 2D games,
  physics simulations, or real-time canvas architectures.
---

# Web Game Development & 2D Canvas Engineering

> **Scope**: High-performance HTML5 2D Canvas, deterministic fixed-timestep game loops, physics simulation with Matter.js, sprite sheets, input handling (keyboard, touch, gamepad), spatial partitioning, and audio management with Web Audio API.

---

## When to Activate

- Designing and implementing 2D browser games or physics simulations
- Integrating Matter.js or custom rigid-body physics
- Structuring game architecture (Entity-Component-System or Object-Oriented state machines)
- Managing canvas animation loops, delta timing, and frame budget
- Handling responsive multi-touch, keyboard, and gamepad input
- Optimizing canvas render performance and eliminating frame drops

---

## 1. Deterministic Game Loop & Frame Timing

### The Fixed Timestep Loop ("Fix Your Timestep")
Never update physics with variable delta time (`dt`), which causes unstable physics calculations, clipping through walls, and non-deterministic behavior. Decouple simulation updates from display rendering:

```javascript
let lastTime = performance.now();
let accumulator = 0;
const TIMESTEP = 1000 / 60; // 60 updates per second (16.67ms)

function gameLoop(currentTime) {
  const frameTime = Math.min(currentTime - lastTime, 250); // Cap spiral of death
  lastTime = currentTime;
  accumulator += frameTime;

  // Fixed physics updates
  while (accumulator >= TIMESTEP) {
    updatePhysics(TIMESTEP / 1000);
    accumulator -= TIMESTEP;
  }

  // Render with interpolation between physics frames
  const alpha = accumulator / TIMESTEP;
  render(alpha);

  requestAnimationFrame(gameLoop);
}
requestAnimationFrame(gameLoop);
```

---

## 2. 2D Canvas Performance Architecture

### High-DPI Display Setup
Always scale the canvas buffer by `window.devicePixelRatio` while keeping CSS dimensions fixed to eliminate blurry graphics:
```javascript
function resizeCanvas(canvas, width, height) {
  const dpr = Math.min(window.devicePixelRatio || 1, 2);
  canvas.width = width * dpr;
  canvas.height = height * dpr;
  canvas.style.width = `${width}px`;
  canvas.style.height = `${height}px`;

  const ctx = canvas.getContext('2d');
  ctx.scale(dpr, dpr);
  return ctx;
}
```

### Offscreen Canvas & Pre-Rendering
- Pre-render complex static backgrounds or procedural textures onto an offscreen canvas (`new OffscreenCanvas()` or an in-memory `<canvas>`).
- Draw the pre-rendered canvas in a single fast `ctx.drawImage(offscreenCanvas, 0, 0)` call rather than redrawing individual primitives every frame.

### Object Pooling
Never instantiate short-lived objects (bullets, damage numbers, particle effects) in the inner game loop. Memory allocation triggers JavaScript Garbage Collection pauses that cause visible stutter. Pre-allocate an array of reusable objects and toggle their `active` state.

---

## 3. Physics with Matter.js

### Rigid Body Simulation
```javascript
import Matter from 'matter-js';

const { Engine, Render, Runner, Bodies, Composite } = Matter;

const engine = Engine.create({
  gravity: { x: 0, y: 1 }
});

// Create boundaries
const ground = Bodies.rectangle(400, 590, 810, 60, { isStatic: true });
const player = Bodies.circle(100, 100, 20, {
  restitution: 0.5,
  friction: 0.05
});

Composite.add(engine.world, [ground, player]);
```

### Collision Handling & Filtering
Use collision categories (bitmasks) to prevent friendly fire or unwanted collisions between specific entity groups:
```javascript
const CATEGORY_PLAYER = 0x0001;
const CATEGORY_ENEMY  = 0x0002;
const CATEGORY_BULLET = 0x0004;

// Player bullet collides with enemies, but not the player
playerBullet.collisionFilter = {
  category: CATEGORY_BULLET,
  mask: CATEGORY_ENEMY
};
```

---

## 4. Multi-Input & Audio Architecture

### Input Management
- Implement a unified Input Manager that abstracts raw events (`keydown`, `touchstart`, `pointerdown`) into semantic game actions (`JUMP`, `ATTACK`, `MOVE_LEFT`).
- Prevent default browser behaviors for game keys (Arrow keys, Spacebar) only when the game canvas has active focus.

### Web Audio API
- Modern browsers block audio autoplay until the user interacts with the page. Initialize the `AudioContext` only after the first user click or keypress:
  ```javascript
  let audioCtx = null;
  function ensureAudioContext() {
    if (!audioCtx) {
      audioCtx = new (window.AudioContext || window.webkitAudioContext)();
    }
    if (audioCtx.state === 'suspended') {
      audioCtx.resume();
    }
  }
  ```

---

## 5. Verification Checklist

- [ ] Game maintains a rock-solid 60fps on standard desktop and mobile hardware.
- [ ] Physics simulation is deterministic and does not clip through boundaries at low frame rates.
- [ ] Memory footprint is flat over extended gameplay (verified zero GC spikes via object pooling).
- [ ] Canvas is sharp on Retina / High-DPI screens without blurriness.
- [ ] Audio respects browser autoplay policies and supports mute toggling.
