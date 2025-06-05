document.addEventListener('DOMContentLoaded', function () {
    // Initialize Choices.js for grade and subject multi-select dropdowns
    const classSelect = document.querySelector('.grade-select-class');
    const subjectSelect = document.querySelector('.grade-select-subject');
    const filterForm = document.querySelector('.filter-form');
    const gradesInput = document.querySelector('#grades');
    const subjectsInput = document.querySelector('#subjects');
    const sortInput = document.querySelector('#sort');

    // Check if required elements exist
    if (!classSelect || !subjectSelect || !filterForm || !gradesInput || !subjectsInput || !sortInput) {
        console.error('One or more required DOM elements are missing.');
        return;
    }

    // Get URL parameters
    const urlParams = new URLSearchParams(window.location.search);
    const selectedGrades = urlParams.get('grades') ? urlParams.get('grades').split(',') : [];
    const selectedSubjects = urlParams.get('subjects') ? urlParams.get('subjects').split(',') : [];
    const selectedSort = urlParams.get('sort') || '';

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
    if (selectedGrades.length > 0) {
        classChoices.setChoiceByValue(selectedGrades);
        gradesInput.value = selectedGrades.join(',');
    }

    // Restore selected subjects
    if (selectedSubjects.length > 0) {
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

    // Handle filter form submission
    filterForm.addEventListener('submit', function (event) {
        event.preventDefault();

        try {
            // Get selected grades and join them into a comma-separated string
            const selectedGrades = classChoices.getValue(true);
            gradesInput.value = Array.isArray(selectedGrades) ? selectedGrades.join(',') : '';

            // Get selected subjects and join them into a comma-separated string
            const selectedSubjects = subjectChoices.getValue(true);
            subjectsInput.value = Array.isArray(selectedSubjects) ? selectedSubjects.join(',') : '';

            // Get selected sort option
            const selectedSortOption = document.querySelector('input[name="sort"]:checked');
            sortInput.value = selectedSortOption ? selectedSortOption.value : '';

            // Log form data for debugging
            console.log('Form data:', {
                grades: gradesInput.value,
                subjects: subjectsInput.value,
                sort: sortInput.value
            });

            // Submit the form
            filterForm.submit();
        } catch (error) {
            console.error('Error processing form submission:', error);
        }
    });
});