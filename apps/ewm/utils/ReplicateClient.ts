import { getEnv, ENV_KEY } from '@/utils/env';
import Replicate from 'replicate';
import { QrCodeControlNetRequest, QrCodeControlNetResponse } from './types';

export class ReplicateClient {
  replicate: Replicate;

  constructor(apiKey: string) {
    this.replicate = new Replicate({
      auth: apiKey,
    });
  }

  /**
   * Generate a QR code.
   */
  generateQrCode = async (
    request: QrCodeControlNetRequest,
  ): Promise<string> => {
    const output = (await this.replicate.run(
      'zylim0702/qr_code_controlnet:628e604e13cf63d8ec58bd4d238474e8986b054bc5e1326e50995fdbc851c557',
      {
        input: {
          url: request.url,
          prompt: request.prompt,
          qr_conditioning_scale: request.qr_conditioning_scale,
          num_inference_steps: request.num_inference_steps,
          guidance_scale: request.guidance_scale,
          negative_prompt: request.negative_prompt,
        },
      },
    )) as QrCodeControlNetResponse;

    if (!output) {
      throw new Error('Failed to generate QR code');
    }

    return output[0];
  };
}

const apiKey = getEnv(ENV_KEY.REPLICATE_API_KEY);

let _replicateClient: ReplicateClient | null = null;

export const getReplicateClient = (): ReplicateClient => {
  if (!_replicateClient) {
    if (!apiKey) {
      throw new Error('REPLICATE_API_KEY is not set');
    }
    _replicateClient = new ReplicateClient(apiKey);
  }
  return _replicateClient;
};

// For backward compatibility, but will only work if API key is available
export const replicateClient = (() => {
  try {
    return getReplicateClient();
  } catch {
    // Return a stub that will fail at runtime instead of build time
    return null as unknown as ReplicateClient;
  }
})();
