public class FloatingWindowService extends Service {

    private WindowManager windowManager;
    private ImageView imageView;
    private Bitmap currentBitmap;

    @Override
    public void onCreate() {
        super.onCreate();

        windowManager = (WindowManager) getSystemService(WINDOW_SERVICE);

        // 创建 ImageView（布局完全动态）
        imageView = new ImageView(this);
        imageView.setLayoutParams(new ViewGroup.LayoutParams(600, 600));

        // 悬浮窗参数
        WindowManager.LayoutParams params = new WindowManager.LayoutParams(
                600, 600,
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,  // Android 8.0+
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE | WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
                PixelFormat.TRANSLUCENT
        );
        params.gravity = Gravity.TOP | Gravity.LEFT;
        params.x = 100;
        params.y = 100;

        // 加入 WindowManager
        windowManager.addView(imageView, params);

        // 初始加载一张图片（测试用）
        updateImage("/sdcard/test.jpg");
    }

    /**
     * 切换图片：每次更换前先释放旧图像资源
     */
    public void updateImage(String path) {
        // 回收旧图
        if (currentBitmap != null && !currentBitmap.isRecycled()) {
            currentBitmap.recycle();
        }

        // 加载新图
        currentBitmap = BitmapFactory.decodeFile(path);
        if (currentBitmap != null) {
            imageView.setImageBitmap(currentBitmap);
        } else {
            imageView.setBackgroundColor(Color.RED); // 显示错误提示
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (imageView != null) {
            windowManager.removeView(imageView);
        }
        if (currentBitmap != null && !currentBitmap.isRecycled()) {
            currentBitmap.recycle();
        }
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
