# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.0-base

# install custom nodes into comfyui
RUN comfy node install --exit-on-fail RES4LYF --mode remote
RUN comfy node install --exit-on-fail comfyui-impact-pack@8.28.2
RUN comfy node install --exit-on-fail rgthree-comfy@1.0.2512112053
RUN comfy node install --exit-on-fail comfyui_ultimatesdupscale@1.6.2
RUN comfy node install --exit-on-fail comfyui-custom-scripts@1.2.5
RUN comfy node install --exit-on-fail comfyui-impact-subpack@1.3.5


# Install aria2c for FAST parallel downloads (90% faster than curl)
RUN apt-get update && apt-get install -y aria2 && rm -rf /var/lib/apt/lists/*

# Download your Vision model from HuggingFace with 8 parallel connections (recommended safe value)
RUN echo "Downloading uncanny checkpoint with aria2c..." && \
    aria2c -s 8 -x 8 --dir=/comfyui/models/checkpoints \
    --out=uncannyPhotorealism_v13.safetensors \
    "https://huggingface.co/DocApoc/Vision_mark10/resolve/main/uncannyPhotorealism_v13.safetensors" && \
    echo "Download complete!"

RUN echo "Downloading lenovo Lora with aria2c..." && \
    aria2c -s 8 -x 8 --dir=/comfyui/models/checkpoints \
    --out=lenovo_chroma.safetensors \
    "https://huggingface.co/DocApoc/Vision_mark10/resolve/main/lenovo_chroma.safetensors" && \
    echo "Download complete!"

RUN echo "Downloading cinematic detail lora with aria2c..." && \
    aria2c -s 8 -x 8 --dir=/comfyui/models/checkpoints \
    --out=high_cinematic_detail_s_m_1.0.safetensors \
    "https://huggingface.co/DocApoc/Vision_mark10/resolve/main/Chroma_high_cinematic_detail_s_m_1.0.safetensors" && \
    echo "Download complete!"

RUN comfy model download --url https://huggingface.co/silveroxides/flan-t5-xxl-encoder-only/blob/main/flan-t5-xxl-fp16.safetensors --relative-path models/clip --filename flan-t5-xxl-fp16.safetensors
RUN comfy model download --url https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8m.pt --relative-path models/ultralytics/bbox --filename face_yolov8m.pt
RUN comfy model download --url https://github.com/Phhofm/models/releases/download/4xNomosWebPhoto_RealPLKSR/4xNomosWebPhoto_RealPLKSR.safetensors --relative-path models/upscale_models --filename 4xNomosWebPhoto_RealPLKSR.safetensors
RUN comfy model download --url https://dl.fbaipublicfiles.com/segment_anything/sam_vit_b_01ec64.pth --relative-path models/sams --filename sam_vit_b_01ec64.pth
RUN comfy model download --url https://huggingface.co/Comfy-Org/Lumina_Image_2.0_Repackaged/resolve/main/split_files/vae/ae.safetensors --relative-path models/vae --filename ae.safetensors
