/*
产生声波信息的工具类
 */
export class WaveProducer {
  private tone: Uint8Array;
  private isPrepare: boolean;

  constructor() {
    this.tone = new Uint8Array(4 * 44100);
    this.isPrepare = false;
  }

  prepare(): void {
    if (this.isPrepare) {
      return;
    }
    for (let i = 0; i < 2 * WaveProducer.SAMPLE_RATE; i++) {
      const cosWave = (WaveProducer.WAV_RANGE * Math.cos(2 * Math.PI * WaveProducer.FREQUENCY * i / WaveProducer.SAMPLE_RATE));
      this.tone[2 * i] = cosWave & 0xff;
      this.tone[2 * i + 1] = (cosWave & 0xff00) >> 8;
    }
    this.isPrepare = true;
  }

  static readonly SAMPLE_RATE = 44100;
  static readonly FREQUENCY = 19000;
  private static readonly WAV_RANGE = 32767;
}

