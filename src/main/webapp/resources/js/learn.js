/**
 * Ứng dụng chính để quản lý trang học tập.
 * Quản lý YouTube Player, tiến trình học tập, và giao diện người dùng.
 */
const LearningApp = (function () {
    console.log("Tôi đã được nhúng vào");
    let player = null;
    let currentLessonId = null;
    let lastWatchedTime = 0;
    let isYouTubeAPIReady = false;
    let pendingLessonId = null;
    let config = {};
    let lessons = {};
    let timeUpdateInterval = null;

    /**
     * Khởi tạo ứng dụng.
     * @param {Object} learningConfig - Cấu hình từ server (userId, subjectId, packageId, defaultLessonId).
     * @param {Object} lessonsData - Dữ liệu các bài học.
     */
    function init(learningConfig, lessonsData) {
        console.log('Khởi tạo LearningApp, config:', learningConfig, 'lessonsData:', lessonsData);
        config = learningConfig;
        lessons = lessonsData;

        if (!config.userId || !config.subjectId || !config.packageId) {
            console.error('Thiếu thông tin cấu hình cần thiết.');
            return;
        }

        registerEvents();
        window.onYouTubeIframeAPIReady = onYouTubeAPIReady;
        if (config.defaultLessonId) {
            loadLessonDetails(config.defaultLessonId);
        }
    }

    /**
     * Đăng ký các sự kiện UI.
     */
    function registerEvents() {
        $('.list-group-item-action').on('click', function (e) {
            e.preventDefault();
            const lessonId = $(this).data('lesson-id');
            console.log('Click lesson:', lessonId);
            loadLessonDetails(lessonId);
        });

        window.addEventListener('beforeunload', () => {
            console.log('Rời trang, lưu tiến trình cho lessonId:', currentLessonId);
            if (currentLessonId && player && player.getCurrentTime) {
                lastWatchedTime = Math.floor(player.getCurrentTime());
                saveToLocalStorage(currentLessonId, lastWatchedTime, lessons[currentLessonId].isCompleted);
                syncProgressToBackend(currentLessonId);
            }
            if (timeUpdateInterval) {
                clearInterval(timeUpdateInterval);
                timeUpdateInterval = null;
            }
        });
    }

    /**
     * Xử lý khi YouTube API sẵn sàng.
     */
    function onYouTubeAPIReady() {
        console.log('YouTube API đã sẵn sàng');
        isYouTubeAPIReady = true;
        if (pendingLessonId) {
            console.log('Khởi tạo player cho pendingLessonId:', pendingLessonId);
            initializeYouTubePlayer(pendingLessonId);
            pendingLessonId = null;
        }
    }

    /**
     * Load chi tiết bài học và cập nhật UI.
     * @param {number} lessonId - ID của bài học.
     */
    function loadLessonDetails(lessonId) {
        console.log('Load chi tiết bài học:', lessonId);
        if (!lessons[lessonId]) {
            console.error('Không tìm thấy bài học:', lessonId);
            updateUIForEmptyLesson();
            return;
        }

        if (currentLessonId && currentLessonId !== lessonId) {
            syncProgressToBackend(currentLessonId);
        }

        currentLessonId = lessonId;
        const lesson = lessons[lessonId];

        updateLessonUI(lesson);
        initializeYouTubePlayer(lessonId);
        loadProgress(lessonId);

        new bootstrap.Tab(document.querySelector('#description-tab')).show();
    }

    /**
     * Cập nhật giao diện với thông tin bài học.
     * @param {Object} lesson - Dữ liệu bài học.
     */
    function updateLessonUI(lesson) {
        console.log('Cập nhật UI cho lesson:', lesson);
        $('#lessonTitle').text(lesson.lessonName || 'Không tìm thấy bài học');
        $('#lessonDescription').text(lesson.lessonDescription || 'Không có mô tả.');

        const materialsList = $('#materialsList');
        materialsList.empty();
        if (lesson.materials && lesson.materials.length > 0) {
            lesson.materials.forEach(material => {
                materialsList.append(`
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        <a href="/files/taiLieu/${material}" target="_blank">${material}</a>
                        <a href="/files/taiLieu/${material}" download="${material}"><i class="bi bi-download"></i></a>
                    </li>
                `);
            });
        } else {
            materialsList.append('<li class="list-group-item text-muted">Không có tài liệu.</li>');
        }

        $('.list-group-item-action').removeClass('active');
        $(`.list-group-item-action[data-lesson-id="${lesson.lessonId}"]`).addClass('active');
    }

    /**
     * Cập nhật UI khi không tìm thấy bài học.
     */
    function updateUIForEmptyLesson() {
        console.log('Cập nhật UI cho bài học không tìm thấy');
        $('#lessonTitle').text('Không tìm thấy bài học');
        $('#lessonDescription').text('Không có mô tả.');
        $('#materialsList').html('<li class="list-group-item text-muted">Không có tài liệu.</li>');
        $('#videoContainer').hide();
    }

    /**
     * Khởi tạo YouTube Player cho bài học.
     * @param {number} lessonId - ID của bài học.
     */
    function initializeYouTubePlayer(lessonId) {
        console.log('Khởi tạo player cho lessonId:', lessonId);
        if (!isYouTubeAPIReady) {
            console.log('YouTube API chưa sẵn sàng, lưu pendingLessonId:', lessonId);
            pendingLessonId = lessonId;
            return;
        }

        const lesson = lessons[lessonId];
        console.log('Lesson:', lesson);
        if (!lesson || !lesson.videoSrc) {
            console.log('Không có lesson hoặc videoSrc, ẩn videoContainer');
            $('#videoContainer').hide();
            return;
        }

        const videoId = extractYouTubeVideoId(lesson.videoSrc);
        console.log('VideoId:', videoId);
        if (!videoId) {
            console.error('URL YouTube không hợp lệ:', lesson.videoSrc);
            $('#videoContainer').hide();
            return;
        }

        if (player) {
            player.destroy();
            player = null;
        }

        $('#videoContainer').empty().append(`
            <iframe id="lessonVideo" frameborder="0"
                    allow="accelerometer; autoplay;"
                    allowfullscreen></iframe>
        `);
        const videoSrc = lesson.videoSrc + (lesson.videoSrc.includes('?') ? '&' : '?') + 'enablejsapi=1';
        $('#lessonVideo').attr('src', videoSrc);
        $('#videoContainer').show();

        player = new YT.Player('lessonVideo', {
            height: '100%',
            width: '100%',
            videoId: videoId,
            playerVars: {
                'enablejsapi': 1,
                'controls': 0,          // Ẩn thanh điều hướng (chỉ hiển thị play/pause cơ bản)
                'iv_load_policy': 3,    // Ẩn chú thích (annotations)
                'modestbranding': 1,    // Giảm độ nổi bật của logo YouTube
                'rel': 0,               // Ẩn video liên quan khi kết thúc
                'autoplay': 0,           // Tắt autoplay để tránh xung đột
                'playlist': videoId
            },
            events: {
                'onReady': () => {
                    console.log('Player sẵn sàng cho lessonId:', lessonId);
                    loadProgress(lessonId);
                },
                'onStateChange': (event) => handlePlayerStateChange(event, lessonId),
                'onError': (event) => {
                    console.error('Lỗi YouTube Player:', event.data);
                    $('#videoContainer').hide();
                }
            }
        });
    }

    /**
     * Xử lý sự kiện thay đổi trạng thái của player.
     * @param {Object} event - Sự kiện từ YouTube Player.
     * @param {number} lessonId - ID của bài học.
     */
    function handlePlayerStateChange(event, lessonId) {
        console.log('Trạng thái player:', event.data, 'lessonId:', lessonId);
        if (event.data === YT.PlayerState.PLAYING) {
            if (!timeUpdateInterval) {
                timeUpdateInterval = setInterval(() => {
                    if (player && player.getCurrentTime) {
                        lastWatchedTime = Math.floor(player.getCurrentTime());
                        console.log('Cập nhật lastWatchedTime:', lastWatchedTime);
                    }
                }, 1000);
            }
        } else if (event.data === YT.PlayerState.PAUSED || event.data === YT.PlayerState.ENDED) {
            if (timeUpdateInterval) {
                clearInterval(timeUpdateInterval);
                timeUpdateInterval = null;
            }
            if (player && player.getCurrentTime) {
                lastWatchedTime = Math.floor(player.getCurrentTime());
                if (isNaN(lastWatchedTime)) {
                    console.error('Thời gian xem không hợp lệ:', lastWatchedTime);
                    return;
                }
                if (event.data === YT.PlayerState.ENDED) {
                    lessons[lessonId].isCompleted = true;
                }
                console.log('Lưu tiến trình:', { lessonId, lastWatchedTime, isCompleted: lessons[lessonId].isCompleted });
                saveToLocalStorage(lessonId, lastWatchedTime, lessons[lessonId].isCompleted);
            }
        }
    }

    /**
     * Trích xuất YouTube video ID từ URL.
     * @param {string} url - URL video YouTube.
     * @returns {string|null} - Video ID hoặc null nếu không hợp lệ.
     */
    function extractYouTubeVideoId(url) {
        if (!url) return null;
        const regex = /(?:youtube\.com\/(?:embed\/|watch\?v=)|youtu\.be\/)([^?&\s]+)/;
        const match = url.match(regex);
        console.log('Extract videoId from URL:', url, 'Result:', match ? match[1] : null);
        return match ? match[1] : null;
    }

    /**
     * Lưu tiến trình vào localStorage.
     * @param {number} lessonId - ID của bài học.
     * @param {number} watchedTime - Thời gian đã xem (giây).
     * @param {boolean} isCompleted - Trạng thái hoàn thành.
     */
    function saveToLocalStorage(lessonId, watchedTime, isCompleted) {
        if (!config.userId || !lessonId || !config.subjectId || !config.packageId) return;
        const storageKey = `lesson_progress_${config.userId}_${lessonId}`;
        const progress = {
            watchedTime: watchedTime,
            isCompleted: isCompleted,
            timestamp: Date.now(),
            subjectId: config.subjectId,
            packageId: config.packageId
        };
        localStorage.setItem(storageKey, JSON.stringify(progress));
    }

    /**
     * Đồng bộ tiến trình với backend.
     * @param {number} lessonId - ID của bài học.
     */
    async function syncProgressToBackend(lessonId) {
        if (!config.userId || !lessonId || !config.subjectId || !config.packageId) return;
        const storageKey = `lesson_progress_${config.userId}_${lessonId}`;
        const progress = JSON.parse(localStorage.getItem(storageKey));
        if (!progress) return;

        const data = {
            userId: config.userId,
            lessonId: lessonId,
            subjectId: config.subjectId,
            packageId: config.packageId,
            watchedTime: progress.watchedTime || 0,
            isCompleted: progress.isCompleted || false
        };

        try {
            const response = await fetch('/api/lesson-progress/save', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${localStorage.getItem('jwtToken')}`
                },
                body: JSON.stringify(data)
            });
            if (response.ok) {
                localStorage.removeItem(storageKey);
            } else {
                console.error('Lỗi đồng bộ tiến trình:', response.status);
            }
        } catch (error) {
            console.error('Lỗi mạng khi đồng bộ:', error);
        }
    }

    /**
     * Load tiến trình học tập từ localStorage hoặc backend.
     * @param {number} lessonId - ID của bài học.
     */
    async function loadProgress(lessonId) {
        if (!config.userId || !lessonId || !config.subjectId || !config.packageId) return;
        const storageKey = `lesson_progress_${config.userId}_${lessonId}`;
        const localProgress = JSON.parse(localStorage.getItem(storageKey));

        if (localProgress && localProgress.watchedTime) {
            lastWatchedTime = localProgress.watchedTime;
            if (player && player.seekTo && isYouTubeAPIReady) {
                player.seekTo(lastWatchedTime, true);
            }
            return;
        }

        try {
            const response = await fetch(`/api/lesson-progress?userId=${config.userId}&lessonId=${lessonId}&subjectId=${config.subjectId}&packageId=${config.packageId}`, {
                headers: {
                    'Authorization': `Bearer ${localStorage.getItem('jwtToken')}`
                }
            });
            if (response.ok) {
                const progress = await response.json();
                lastWatchedTime = progress.watchedTime || 0;
                if (player && player.seekTo && isYouTubeAPIReady) {
                    player.seekTo(lastWatchedTime, true);
                }
                saveToLocalStorage(lessonId, progress.watchedTime, progress.isCompleted);
            } else {
                lastWatchedTime = 0;
            }
        } catch (error) {
            console.error('Lỗi khi tải tiến trình:', error);
            lastWatchedTime = 0;
        }
    }

    return {
        init
    };
})();