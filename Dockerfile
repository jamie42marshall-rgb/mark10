# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.0-base

# install custom nodes into comfyui
RUN comfy node install --exit-on-fail RES4LYF --mode remote
RUN comfy node install --exit-on-fail comfyui-impact-pack@8.28.2
RUN comfy node install --exit-on-fail rgthree-comfy@1.0.2512112053
RUN comfy node install --exit-on-fail comfyui_ultimatesdupscale@1.6.2
RUN comfy node install --exit-on-fail comfyui-custom-scripts@1.2.5
RUN comfy node install --exit-on-fail comfyui-impact-subpack@1.3.5

# Copy local models (now possible because build context includes both folders)
COPY models/uncannyPhotorealism_v13.safetensors /comfyui/models/diffusion_models/
COPY models/lenovo_chroma.safetensors /comfyui/models/loras/
COPY models/high_cinematic_detail_s_m_1.0.safetensors /comfyui/models/loras/

RUN comfy model download --url https://huggingface.co/silveroxides/flan-t5-xxl-encoder-only/blob/main/flan-t5-xxl-fp16.safetensors --relative-path models/clip --filename flan-t5-xxl-fp16.safetensors
RUN comfy model download --url https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8m.pt --relative-path models/ultralytics/bbox --filename face_yolov8m.pt
RUN comfy model download --url https://github.com/Phhofm/models/releases/download/4xNomosWebPhoto_RealPLKSR/4xNomosWebPhoto_RealPLKSR.safetensors --relative-path models/upscale_models --filename 4xNomosWebPhoto_RealPLKSR.safetensors
RUN comfy model download --url https://dl.fbaipublicfiles.com/segment_anything/sam_vit_b_01ec64.pth --relative-path models/sams --filename sam_vit_b_01ec64.pth
RUN comfy model download --url https://huggingface.co/Comfy-Org/Lumina_Image_2.0_Repackaged/resolve/main/split_files/vae/ae.safetensors --relative-path models/vae --filename ae.safetensors
