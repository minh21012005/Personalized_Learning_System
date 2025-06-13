document.addEventListener('DOMContentLoaded', function () {
    // Initialize Choices.js for grade and subject multi-select dropdowns
    const classSelect = document.querySelector('.grade-select-class');
    const subjectSelect = document.querySelector('.grade-select-subject');
    const filterForm = document.querySelector('.filter-form');
    const searchForm = document.querySelector('.search-form');
    const gradesInput = document.querySelector('#grades');
    const subjectsInput = document.querySelector('#subjects');
    const sortInput = document.querySelector('#sort');

    // Check if required elements exist
    if (!classSelect || !subjectSelect || !filterForm || !searchForm || !gradesInput || !subjectsInput || !sortInput) {
        console.error('One or more required DOM elements are missing.');
        return;
    }

    // Get URL parameters
    const urlParams = new URLSearchParams(window.location.search);
    const selectedGrades = urlParams.get('grades') ? urlParams.get('grades').split(',') : [];
    const selectedSubjects = urlParams.get('subjects') ? urlParams.get('subjects').split(',') : [];
    const selectedSort = urlParams.get('sort') || '';
    const courseParam = urlParams.get('course') || '';

    // Initialize Choices.js for grade selection
    const classChoices = new Choices(classSelect, {
        removeItemButton: true,
        placeholderValue: 'Chọn khối lớp',
        searchEnabled: true,
        noChoicesText: 'Không có khối lớp nào',
        itemSelectText: 'Nhấn để chọn'
    });

    // Initialize Choices.js for subject selection
    const subjectChoices = new Choices(subjectSelect, {
        removeItemButton: true,
        placeholderValue: 'Chọn môn học',
        searchEnabled: true,
        noChoicesText: 'Không có môn học nào',
        itemSelectText: 'Nhấn để chọn'
    });

    // Restore selected grades
    if (selectedGrades.length > 0 && selectedGrades[0] !== '') {
        classChoices.setChoiceByValue(selectedGrades);
        gradesInput.value = selectedGrades.join(',');
    }

    // Restore selected subjects
    if (selectedSubjects.length > 0 && selectedSubjects[0] !== '') {
        subjectChoices.setChoiceByValue(selectedSubjects);
        subjectsInput.value = selectedSubjects.join(',');
    }

    // Restore selected sort option
    if (selectedSort) {
        const sortOption = document.querySelector(`input[name="sort"][value="${selectedSort}"]`);
        if (sortOption) {
            sortOption.checked = true;
            sortInput.value = selectedSort;
        }
    }

    // Log for debugging
    console.log('Restored grades:', selectedGrades);
    console.log('Restored subjects:', selectedSubjects);
    console.log('Restored sort:', selectedSort);
    console.log('Restored course:', courseParam);

    // Function to build query string, excluding empty parameters
    function buildQueryString(params) {
        const query = new URLSearchParams();
        for (const [key, value] of Object.entries(params)) {
            if (value && value !== '') {
                query.append(key, value);
            }
        }
        return query.toString();
    }

    // Handle filter form submission
    filterForm.addEventListener('submit', function (event) {
        event.preventDefault();

        try {
            // Get selected grades
            const selectedGrades = classChoices.getValue(true);
            const gradesValue = Array.isArray(selectedGrades) && selectedGrades.length > 0 ? selectedGrades.join(',') : '';

            // Get selected subjects
            const selectedSubjects = subjectChoices.getValue(true);
            const subjectsValue = Array.isArray(selectedSubjects) && selectedSubjects.length > 0 ? selectedSubjects.join(',') : '';

            // Get selected sort option
            const selectedSortOption = document.querySelector('input[name="sort"]:checked');
            const sortValue = selectedSortOption ? selectedSortOption.value : '';

            // Get course value
            const courseValue = filterForm.querySelector('input[name="course"]').value || '';

            // Build query string with non-empty parameters
            const params = {
                course: courseValue,
                grades: gradesValue,
                subjects: subjectsValue,
                sort: sortValue
            };

            // Log for debugging
            console.log('Filter form data:', params);

            // Redirect to new URL
            const queryString = buildQueryString(params);
            window.location.href = '/parent/course' + (queryString ? '?' + queryString : '');
        } catch (error) {
            console.error('Error processing filter form submission:', error);
        }
    });

    // Handle search form submission
    searchForm.addEventListener('submit', function (event) {
        event.preventDefault();

        try {
            // Get current values
            const courseValue = searchForm.querySelector('input[name="course"]').value.trim();
            const gradesValue = searchForm.querySelector('input[name="grades"]').value;
            const subjectsValue = searchForm.querySelector('input[name="subjects"]').value;
            const sortValue = searchForm.querySelector('input[name="sort"]').value;

            // Build query string with non-empty parameters
            const params = {
                course: courseValue,
                grades: gradesValue,
                subjects: subjectsValue,
                sort: sortValue
            };

            // Log for debugging
            console.log('Search form data:', params);

            // Redirect to new URL
            const queryString = buildQueryString(params);
            window.location.href = '/parent/course' + (queryString ? '?' + queryString : '');
        } catch (error) {
            console.error('Error processing search form submission:', error);
        }
    });
});