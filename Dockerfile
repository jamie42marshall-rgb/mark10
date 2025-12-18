# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.0-base

# install custom nodes into comfyui
RUN comfy node install --exit-on-fail comfyui-impact-pack@8.28.0
RUN comfy node install --exit-on-fail comfyui_ultimatesdupscale@1.6.0
RUN comfy node install --exit-on-fail RES4LYF
RUN comfy node install --exit-on-fail comfyui-impact-subpack@1.3.5
RUN comfy node install --exit-on-fail comfyui-custom-scripts@1.2.5
RUN comfy node install --exit-on-fail comfyui_diffusionmodel_fp8_converter@1.0.0



# Force cache bust for curl installation
ARG CACHEBUST=1

# Install curl for  downloads
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*



# download models into comfyui
# Download your private Vision model from Hugging Face
RUN curl -L -H "Authorization: Bearer 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" \
    "https://huggingface.co/DocApoc/Vision_mark10/resolve/main/mark10_00001_.safetensors" \
    -o /comfyui/models/checkpoints/mark10_00001_.safetensorsRUN comfy model download --url https://dl.fbaipublicfiles.com/segment_anything/sam_vit_b_01ec64.pth --relative-path models/sams --filename sam_vit_b_01ec64.pth
RUN comfy model download --url https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8m.pt --relative-path models/ultralytics/bbox --filename face_yolov8m.pt
RUN comfy model download --url https://github.com/Phhofm/models/releases/download/4xNomosWebPhoto_RealPLKSR/4xNomosWebPhoto_RealPLKSR.safetensors --relative-path models/upscale_models --filename 4xNomosWebPhoto_RealPLKSR.safetensors

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/
