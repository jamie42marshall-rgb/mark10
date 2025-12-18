# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.0-base

# install custom nodes into comfyui
RUN comfy node install --exit-on-fail comfyui-impact-pack@8.28.0
RUN comfy node install --exit-on-fail comfyui_ultimatesdupscale@1.6.0
RUN comfy node install --exit-on-fail RES4LYF
RUN comfy node install --exit-on-fail comfyui-impact-subpack@1.3.5
RUN comfy node install --exit-on-fail comfyui-custom-scripts@1.2.5
RUN comfy node install --exit-on-fail comfyui_diffusionmodel_fp8_converter@1.0.0

# Install aria2c for FAST parallel downloads (90% faster than curl)
RUN apt-get update && apt-get install -y aria2 && rm -rf /var/lib/apt/lists/*

# Download your Vision model from HuggingFace with 8 parallel connections (recommended safe value)
RUN echo "Downloading mark10 model with aria2c..." && \
    aria2c -s 8 -x 8 --dir=/comfyui/models/checkpoints \
    --out=mark10_00001_.safetensors \
    "https://huggingface.co/DocApoc/Vision_mark10/resolve/main/mark10_00001_.safetensors" && \
    echo "Download complete!"
    
RUN comfy model download --url https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8m.pt --relative-path models/ultralytics/bbox --filename face_yolov8m.pt
RUN comfy model download --url https://github.com/Phhofm/models/releases/download/4xNomosWebPhoto_RealPLKSR/4xNomosWebPhoto_RealPLKSR.safetensors --relative-path models/upscale_models --filename 4xNomosWebPhoto_RealPLKSR.safetensors
